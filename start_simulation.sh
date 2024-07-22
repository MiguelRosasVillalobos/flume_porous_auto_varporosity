#!/bin/bash
#Miguel Rosas

# Lista de valores para lc
# valores_a=("0.1875" "0.25" "0.375" "0.75" "1.5" "1.125" "0.3" "0" "1.8" "1.4" "0.5" "0.2" "0.3")
# valores_a=("0.1875" "0.375" "0.5625" "0.75" "0.9375" "1.125" "1.3125" "1.5" "1.6875")
# valores_a=("0.075" "0.15" "0.225" "0.45" "0.525" "0.6" "0.675" "0.9375" "1.275" "1.65")
# valores_a=("0.6375" "0.825" "0.9" "0.975" "1.05" "1.2" "1.35" "1.425" "1.575" "1.725")
# valores_a=("0.0675" "0.8325" "0.4425" "0.4575" "0.8175" "0.8325" "1.1925" "1.2075" "1.5675" "1.5825")
# valores_a=("0.435" "0.81" "0.2625" "0.0645" "1.4025" "0.7755" "0.7065" "0.1185")
# valores_a=("0.42375" "0.4275" "1.4025" "0.23625")
# valores_a=("0.4275" "0.2775" "0.3375" "1.0875" "1.1775" "1.17")
# valores_a=("0.0375" "0.429" "1.569" "1.0125" "1.365" "1.5225" "0.0224" "0.7875")
valores_a=("0.3" "1.8" "0.429" "1.1775")

# Verifica si se proporciona la cantidad como argumento
if [ $# -eq 0 ]; then
	echo "Uso: $0 cantidad"
	exit 1
fi

# Obtiene la cantidad desde el primer argumento
cantidad=$1

# Bucle para crear y mover carpetas, editar y genrar mallado
for ((i = 1; i <= $cantidad; i++)); do
	# Genera el nombre de la carpeta
	nombre_carpeta="Case_$i"

	# Crea la carpeta del caso
	mkdir "$nombre_carpeta"

	# Copia carpetas del caso dentro de las carpetasgeneradas
	cp -r "Case_0/0/" "$nombre_carpeta/"
	cp -r "Case_0/0.orig/" "$nombre_carpeta/"
	cp -r "Case_0/constant/" "$nombre_carpeta/"
	cp -r "Case_0/system/" "$nombre_carpeta/"
	cp "Case_0/extract_freesurface_plane.py" "$nombre_carpeta/"
	cp "Case_0/extract_freesurface.sh" "$nombre_carpeta/"
	cp "Case_0/extractor.py" "$nombre_carpeta/"

	# Copia un archivo dentro de la carpeta
	archivo_geo="Case_0/flume.geo"
	archivo_geoi="flume_Case_$i.geo"
	touch "$archivo_geo"
	cp "$archivo_geo" "$nombre_carpeta/$archivo_geoi"

	# Realiza el intercambio en el archivo
	valor_a="${valores_a[i - 1]}"
	sed -i "s/\$aa/$valor_a/g" "$nombre_carpeta/system/setFieldsDict"
	sed -i "s/\$aa/$valor_a/g" "$nombre_carpeta/system/topoSetDict"
	sed -i "s/\$aa/$valor_a/g" "$nombre_carpeta/extractor.py"
	sed -i "s/\$i/$i/g" "$nombre_carpeta/extract_freesurface_plane.py"
	sed -i "s/\$i/$i/g" "$nombre_carpeta/extractor.py"

	#Generar mallado gmsh
	cd "$nombre_carpeta/"
	gmsh "$archivo_geoi" -3

	#Genera mallado OpenFoam
	gmshToFoam "flume_Case_$i.msh"

	#Lineas a eliminar en polymesh/bondary
	lineas_eliminar=("24" "30" "36" "42" "48" "54")

	#Itera sobre las líneas a eliminar y utiliza sed para quitarlas
	for numero_linea in "${lineas_eliminar[@]}"; do
		sed -i "${numero_linea}d" "constant/polyMesh/boundary"
	done

	# Reemplaza "patch" por "wall"
	sed -i '29s/patch/wall/; 35s/patch/wall/ ' "constant/polyMesh/boundary"
	sed -i '23s/patch/empty/ ' "constant/polyMesh/boundary"
	topoSet
	setFields
	decomposePar
	mpirun -np 8 interIsoFoam -parallel
	# ./extract_freesurface.sh
	# python3 extractor.py
	# rm -r ./proce*
	cd ..
done

echo "Proceso completado."
