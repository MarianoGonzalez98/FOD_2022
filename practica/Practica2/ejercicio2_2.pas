{

-------
Se pide realizar un programa con opciones para:

a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
c. Listar el contenido del archivo maestro en un archivo de texto llamado “reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado “reporteDetalle.txt”.

e. Actualizar el archivo maestro de la siguiente manera:
	i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
	ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.
	f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final.
	Deben listarse todos los campos.
	* 
-------
 
Maestro, 1 detalle, mas de un reg por alumno. 

2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. 

Por cada alumno se dispone de su 
 código de alumno, apellido, nombre, cantidad de materias(cursadas) aprobadas sin final y cantidad de materias con final aprobado. 

Además, se tiene un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).

Todos los archivos están ordenados por código de alumno y en el archivo detalle puede haber 0, 1 ó más registros por cada alumno del archivo maestro.

a. Actualizar el archivo maestro de la siguiente manera:

i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.

b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final.
Deben listarse todos los campos.
* 

NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez
}

program ejercicio2_2;

type
	str=string[20];
	rAlu=record
		cod:integer;
		cantCurs:integer;
		cantFinal:integer;
		nombre:str;
		apellido: str;

	end;
	rDet=record
		cod:integer;
		aprobo:char;	//C si aprobo cursada, F si aprobo final
	end;

	fMaestro=file of rAlu;
	fDetalle= file of rDet;


//a. antiguo: Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.

procedure crearMaestro(var arc_mae:fMaestro);
	var
		arc_text:text;
		r:rAlu;
	begin
		assign(arc_text,'alumnos.txt');
		rewrite(arc_mae);
		reset(arc_text);
		
		while not eof(arc_text) do begin
			readln(arc_text,r.cod,r.cantCurs,r.cantFinal,r.nombre);
			readln(arc_text,r.apellido);
			write(arc_mae,r);
		end;
		close(arc_mae);
		close(arc_text);
	end;

//b. antiguo: Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
procedure crearDetalle(var arc_det:fDetalle);
	var
		arc_text:text;
		r:rDet;
	begin
		assign(arc_text,'detalle.txt');
		rewrite(arc_det);
		reset(arc_text);
		
		while not eof(arc_text) do begin
			readln(arc_text,r.cod,r.aprobo);
			write(arc_det,r);
		end;
		close(arc_det);
		close(arc_text);
	end;
	
{a. Actualizar el archivo maestro de la siguiente manera:

i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.
}
procedure leer(var arc_det:fDetalle; var r:rDet);
	begin
		if not eof(arc_det)then
			read(arc_det,r)
		else
			r.cod:=9999;
	end;
	
procedure actualizar(var arc_mae:fMaestro);
	var
		arc_det:fDetalle;
		nombre:str;
		rD:rDet;
		rM:rAlu;
	begin
		writeln('Ingrese nombre del detalle: '); readln(nombre);
		assign(arc_det,nombre);
		reset(arc_mae);
		reset(arc_det);
		leer(arc_det,rD);	//leo el arch detalle
		while (rD.cod<>9999) do begin //mientras no llegue al final del detalle
			read(arc_mae,rM);	//leo un reg del maestro
			while (rM.cod<>rD.cod) do //avanzo en el maestro hasta encotrar el alumno con ese cod
				read(arc_mae,rM); 
			while (rM.cod=rD.cod) do begin
				if (rD.aprobo='C') then
					rM.cantCurs := rM.cantCurs + 1
				else if (rD.aprobo='F') then
					rM.cantFinal:= rM.cantFinal + 1;
				leer(arc_det,rD); //avanzo al siguente reg detalle
			end;
			//cuando termino voy un lugar atras para actualizar el maestro
			seek(arc_mae,filepos(arc_mae)-1);
			write(arc_mae,rM);
		end;
		close(arc_mae);
		close(arc_det);
		
	end;
{b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada aprobada pero no aprobaron el final.
Deben listarse todos los campos.}

procedure listar(var arc_mae:fMaestro);
	var
		arc_text:text;
		r:rAlu;
	begin
		assign(arc_text,'alumnos4mat.txt');
		reset(arc_mae);
		rewrite(arc_text);
		while not eof(arc_mae) do begin
			read(arc_mae,r);
			writeln(arc_text,r.cod,' ',r.cantCurs,' ',r.cantFinal,' ',r.nombre);
			writeln(arc_text,r.apellido);
		end;
		close(arc_mae);
		close(arc_text);
	end;	

	
var
	arc_mae:fMaestro;
begin
	assign(arc_mae,'alumnos');
	actualizar(arc_mae);
	listar(arc_mae);
end.
	
