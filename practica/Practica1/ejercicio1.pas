program ejercicio1;
type
	archivo_num = file of integer;
var
	arc_num: archivo_num;
	num: integer;
	nombreArchivo: string[20];
begin
	//creacion y escritura
	write('Ingrese nombre del archivo:');
	readln(nombreArchivo);
	
	assign(arc_num,nombreArchivo);
	rewrite(arc_num);
	
	write('Ingrese numero:');
	readln(num);
	while (num<>3000) do begin
		write(arc_num,num);
		write('Ingrese numero:');
		readln(num);
	end;
	close(arc_num);
end.
