{
2. Definir un programa que genere un archivo con registros de longitud fija conteniendo información de empleados de una empresa de correo privado.

Se deberá almacenar:
código de empleado, apellido y nombre, dirección, teléfono, D.N.I y fecha nacimiento.

Implementar un algoritmo que, a partir del archivo de datos generado, elimine de forma lógica todo los empleados con DNI inferior a 8.000.000.

Para ello se podrá utilizar algún carácter especial delante de algún campo String a su elección. Ejemplo: ‘*PEDRO.
}
program ejercicio3_2.pas;

type
	stri=string[20];
	rEmpleado = record
		cod:integer;
		apeNombre:stri;
		dire:stri;
		tel:longint;
		dni:longint;
		fechaNac:stri;
	end;
	
	fEmpleados = file of rEmpleado;

procedure leer(var r:rEmpleado);
	begin
		write('-----Codigo de empleado: '); readln(r.cod);
		if r.cod<>-1 then begin
			write('Apellido y nombre: '); readln(r.apeNombre);
			write('Direccion: '); readln(r.dire);
			write('Telefono'); readln(r.tel);
			write('DNI: '); readln(r.dni);
			write('Fecha de nacimiento: '); readln(r.fechaNac);
		end;
	
	end;

procedure borradoLogico(var arc_emple:fEmpleados);
	var
		r:rEmpleado;
	begin
		reset(arc_emple);
		while not eof(arc_emple) do begin
			read(arc_emple,r);
			if r.dni<8000000 then begin
				r.apeNombre:='*' + r.apeNombre; //concatena * al nombre
				seek(arc_emple,filepos(arc_emple)-1); //vuelve una posicion atras
				write(arc_emple,r); //reemplaza el registro
			end;
		end;
	end;

procedure crearArchivo(var arc_emple:fEmpleados);
	var
		r:rEmpleado;
		
	begin
		rewrite(arc_emple);
		leer(r);
		while r.cod<>-1 do begin
			write(arc_emple,r);
			leer(r);
		end;
		close(arc_emple);
	end;
var
	arc_emple:fEmpleados;
begin
	assign(arc_emple,'empleados.dat');
	crearArchivo(arc_emple);
	borradoLogico(arc_emple);
end.
	
