{
* 2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
* }

program ejercicio2;
type
	archivo_num= file of integer;
var
	arc_num: archivo_num;
	num, cant_menores_1500, suma: integer;
	prom:real;
	nombreArchivo:string[20];
begin
	suma:=0;
	cant_menores_1500:=0;
	write('Ingrese nombre de archivo a leer: ');
	readln(nombreArchivo);
	
	assign(arc_num,nombreArchivo);
	reset(arc_num);
	writeln('El contenido es: ');
	while (not eof(arc_num)) do begin
		read(arc_num,num);
		
		if num<1500 then cant_menores_1500:= cant_menores_1500 + 1;
		suma:= suma + num; //para el promedio
		
		write(num,' ');
	end;
	prom:= suma/filesize(arc_num);
	close(arc_num);

	writeln('La cantidad de numeros menores que 1500 son: ',cant_menores_1500);
	writeln('El promedio de los numeros ingresados es: ',prom:2:2);
end.

