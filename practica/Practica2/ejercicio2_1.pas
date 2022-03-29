{
1.Una empresa posee un archivo con información de los ingresos percibidos por diferentes empleados en concepto de comisión,
 de cada uno de ellos se conoce:  código de empleado,nombre y monto de la comisión.
La información del archivo se encuentra ordenada por código de empleado y cada empleado puede aparecer más de una vez en el archivo de comisiones.
 
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte.
En consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.
}

program ejercicio2_1;
type
	str=string[20];
	rEmpleado=record
		cod:integer;
		nombre:str;
		monto:real;
	end;
	
	fEmpleado= file of rEmpleado;

procedure leer(var arc_emple:fEmpleado; var r:rEmpleado);
	begin
		if not eof(arc_emple) then 
			read(arc_emple,r)
		else
			r.cod:=9999;
	end;
	

procedure compactar(var arc_emple:fEmpleado);
	var
		arc_nuevo:fEmpleado;
		r,rCompact:rEmpleado;
	begin
		writeln('Nombre del nuevo archivo:');
		assign(arc_nuevo,'nuevo_2_1');
		rewrite(arc_nuevo);
		reset(arc_emple);
		leer(arc_emple,r);
		while r.cod<>9999 do begin
			rCompact:=r;
			rCompact.monto:=0;
			while(r.cod=rCompact.cod) do begin
				rCompact.monto:= rCompact.monto + r.monto;
				leer(arc_emple,r);
			end;
			write(arc_nuevo,rCompact);
		end;
		close(arc_emple);
		close(arc_nuevo);
	end;


var
	arc_emple:fEmpleado;

begin


end.
