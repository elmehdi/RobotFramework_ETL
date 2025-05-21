#!/bin/bash
# Script pour générer des variables de validation de champs pour Robot Framework à partir d'un fichier CSV
# Usage: ./generate_field_variables.sh <chemin_fichier_csv> [fichier_sortie]
# Si fichier_sortie est fourni, les variables seront écrites dans ce fichier
# Sinon, elles seront affichées sur la sortie standard

# Création du répertoire de logs s'il n'existe pas
LOG_DIR="logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/generation_$(date +%Y%m%d_%H%M%S).log"

# Fonction pour écrire dans le fichier de log
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Vérifier si au moins un chemin de fichier a été fourni
if [ $# -ne 1 ]; then
    log "Usage: $0 <chemin_fichier_csv> "
    exit 1
fi

CSV_FILE="$1"
OUTPUT_FILE="Resources/champs_variables.robot"


log "Démarrage du traitement du fichier $CSV_FILE"

# Vérifier si le fichier existe
if [ ! -f "$CSV_FILE" ]; then
    log "Erreur: Fichier '$CSV_FILE' introuvable."
    exit 1
fi

# Initialiser les tableaux pour les types et tailles de champs
declare -a FIELD_TYPES
declare -a FIELD_SIZES

# Analyser le fichier CSV
# Le format du fichier attendu est:
# Numéro de Colonne,Nom de Colonne,Type de Données,Longueur,Échelle

# Obtenir la dernière ligne pour déterminer le nombre total de champs
LAST_LINE=$(tail -n 1 "$CSV_FILE")
FIELD_COUNT=$(echo "$LAST_LINE" | cut -d ';' -f 1)

log "Traitement de $FIELD_COUNT champs depuis $CSV_FILE..."

# Traiter chaque ligne du fichier CSV
while IFS=';' read -r col_num col_name data_type data_length data_scale; do
    # Ignorer la ligne d'en-tête si elle existe (vérifier si col_num est numérique)
    if ! [[ "$col_num" =~ ^[0-9]+$ ]]; then
        continue
    fi

    # Convertir les types de données Oracle en types de validation Robot Framework
    case "$data_type" in
        "VARCHAR2"|"STRING")
            FIELD_TYPES[$col_num-1]="STRING"
            ;;
        "NUMBER")
            # Vérifier si l'échelle est vide ou 0 (entier) ou > 0 (décimal)
            if [ "$data_scale" = "0" ]; then
                FIELD_TYPES[$col_num-1]="INT"
            else
                FIELD_TYPES[$col_num-1]="DOUBLE"
            fi
            ;;
        "DATE")
            FIELD_TYPES[$col_num-1]="DATE"
            ;;
        *)
            log "Avertissement: Type de données inconnu '$data_type' pour la colonne $col_num. Utilisation de STRING par défaut."
            FIELD_TYPES[$col_num-1]="STRING"
            ;;
    esac

    # Stocker la taille du champ
    FIELD_SIZES[$col_num-1]="$data_length"

    # Journaliser le champ traité
    log "Champ $col_num: $col_name - Type: ${FIELD_TYPES[$col_num-1]}, Taille: ${FIELD_SIZES[$col_num-1]}"

done < "$CSV_FILE"

# Générer un tableau formaté pour l'affichage dans les logs
generate_array_output() {
    local array_output="["
    # Vérifier si les tableaux contiennent des données
    if [ ${#FIELD_TYPES[@]} -eq 0 ] || [ ${#FIELD_SIZES[@]} -eq 0 ]; then
        log "Avertissement: Aucun champ n'a été traité correctement."
        array_output="$array_output]"
        log "Structure des champs: $array_output"
        return
    fi

    # Itérer sur les indices des tableaux
    for i in "${!FIELD_TYPES[@]}"; do
        if [ $i -gt 0 ]; then
            array_output="$array_output, "
        fi
        array_output="$array_output${FIELD_TYPES[$i]}:${FIELD_SIZES[$i]}"
    done
    array_output="$array_output]"
    log "Structure des champs: $array_output"
}

# Générer les définitions de variables Robot Framework
generate_output() {

    echo "*** Settings ***"
    echo "Documentation    Variables associés aux champs trouvés dans le csv"
    echo " "
    echo "*** Variables ***"
    echo "# Structure attendue des fichiers ou JDD"
    echo "@{INPUT_FIELD_COUNT}    $FIELD_COUNT    # Nombre de champs attendus dans les fichiers attendus"

    # Formater les types de champs avec un espacement approprié
    TYPES_STRING=""
    # Vérifier si les tableaux contiennent des données
    if [ ${#FIELD_TYPES[@]} -eq 0 ]; then
        log "Avertissement: Aucun type de champ n'a été traité correctement."
        echo "@{INPUT_FIELD_TYPES}    # Aucun type de champ disponible"
    else
        # Itérer sur les indices des tableaux
        for i in "${!FIELD_TYPES[@]}"; do
            if [ -n "$TYPES_STRING" ]; then
                TYPES_STRING="$TYPES_STRING    "
            fi
            TYPES_STRING="$TYPES_STRING${FIELD_TYPES[$i]}"
        done
        echo "@{INPUT_FIELD_TYPES}    $TYPES_STRING"
    fi

    # Formater les tailles de champs avec un espacement approprié
    SIZES_STRING=""
    # Vérifier si les tableaux contiennent des données
    if [ ${#FIELD_SIZES[@]} -eq 0 ]; then
        log "Avertissement: Aucune taille de champ n'a été traitée correctement."
        echo "@{INPUT_FIELD_SIZES}    # Aucune taille de champ disponible"
    else
        # Itérer sur les indices des tableaux
        for i in "${!FIELD_SIZES[@]}"; do
            if [ -n "$SIZES_STRING" ]; then
                SIZES_STRING="$SIZES_STRING    "
            fi
            SIZES_STRING="$SIZES_STRING${FIELD_SIZES[$i]}"
        done
        echo "@{INPUT_FIELD_SIZES}    $SIZES_STRING"
    fi

    echo "# Variables générées à partir de $CSV_FILE"
    echo "# Générées le $(date)"
}

# Générer l'affichage en tableau pour les logs
generate_array_output

# Écrire dans un fichier ou afficher sur la console
if [ -n "$OUTPUT_FILE" ]; then
    # Créer ou écraser le fichier de sortie
    generate_output > "$OUTPUT_FILE"
    log "Variables Robot Framework écrites dans $OUTPUT_FILE"
else
    # Afficher sur la console
    generate_output
    log "Variables Robot Framework générées avec succès."
fi

log "Traitement terminé. Fichier de log: $LOG_FILE"
