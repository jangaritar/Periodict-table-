#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# Verificar si se proporcionó un argumento
if [ -z "$1" ]; 
  then
    echo "Please provide an element as an argument."
fi
# Determinar si el argumento es un número o una cadena
if [[ $1 =~ ^[0-9]+$ ]]
 then
   # Si es un número, realizar la consulta con atomic_number
  element_data=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $1;")
  else 
   # Si es una cadena, realizar la consulta con symbol o name
  element_data=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$1' OR e.name = '$1';")
fi
# Verificar si se encontró un elemento
if [ -z "$element_data" ]; then
  echo "Element not found."
fi
# Desglosar los datos obtenidos
IFS='|' read -r atomic_number name symbol type atomic_mass melting_point_celsius boiling_point_celsius <<< "$element_data"
# Mostrar la información del elemento
echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."

