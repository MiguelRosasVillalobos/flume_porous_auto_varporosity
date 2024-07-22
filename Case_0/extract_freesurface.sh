# Lista de valores para p
valores_p=("2" "2.07549" "2.15098")
for p in "${valores_p[@]}"; do
	# Crear un archivo temporal para el script modificado
	temp_script="temp_script_$p.py"

	# Copia el script original a un script temporal
	cp extract_freesurface_plane.py $temp_script

	# Usa sed para reemplazar '$p' en el script temporal con el valor actual de p
	sed -i "s/\$p/$p/g" $temp_script

	# Ejecuta el script Python modificado
	pvpython $temp_script

	# Opcional: Eliminar el script temporal después de la ejecución
	rm $temp_script

	# Opcional: Añadir otros comandos aquí si es necesario
done
