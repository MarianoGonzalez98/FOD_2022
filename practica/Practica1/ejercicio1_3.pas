{
* 3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado.
 De cada empleado se registra: 
 número de empleado, apellido, nombre, edad y DNI. 
 Algunos empleados se ingresan con DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y
	i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
		determinado.
	ii. Listar en pantalla los empleados de a uno por línea.
	iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
	
	NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
	única vez
	* 
	* 
4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado
* }
program ejercicio1_3;
type
	str=string[20];
	rEmpleado = record
		num: integer;
		apellido: str;
		nombre: str;
		edad: integer;
		DNI:integer;
	end;
	fEmpleado = file of rEmpleado;

procedure leer (var e:rEmpleado);
	begin
		write('apellido: ');readln(e.apellido);
		if e.apellido <>'fin' then begin
			write('nombre:');readln(e.nombre);
			write('numero:'); readln(e.num);
			write('edad:');readln(e.edad);
			write('dni');readln(e.dni);
		end;
	end;

procedure crear(var arc_empleado: fEmpleado);
	var
		e:rEmpleado;
	
	begin
		rewrite(arc_empleado);
		leer(e);
		while e.apellido<>'fin' do begin
			write(arc_empleado,e);
			leer(e);
		end;
		close(arc_empleado);
	
	end;
{
	i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
		determinado.
	ii. Listar en pantalla los empleados de a uno por línea.
	iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
* }
procedure mostrarDatos(var arc_empleado:fEmpleado);
//Hacer menu de opciones
//Al buscar nombre o apellido, ver si coincide con alguno
	procedure imprimirEmpleado(e: rEmpleado);
	begin
		writeln('Num: ',e.num,' - Nombre y apellido: ',e.nombre,' ',e.apellido,' - Edad: ',e.edad,' - DNI: ',e.dni);
	end;
	var
		e:rEmpleado;
		nombre:str;
	begin
		reset(arc_empleado);
		writeln('i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
		writeln('Ingrese nombre a listar: ');
		readln(nombre);
		while not eof(arc_empleado) do begin
			read(arc_empleado,e);
			if (e.nombre=nombre) then imprimirEmpleado(e);
		end;
		seek(arc_empleado,0);
		writeln('ii. Listar en pantalla los empleados de a uno por línea.');
		while not eof(arc_empleado) do begin
			read(arc_empleado,e);
			imprimirEmpleado(e);
		end;
		seek(arc_empleado,0);
		writeln('iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.');
		while not eof(arc_empleado) do begin
			read(arc_empleado,e);
			if (e.edad>70)then imprimirEmpleado(e);
		end;
		
		close(arc_empleado);
	end;
	
procedure anadirAlFinal(var arc_empleado: fEmpleado);
	var
		e:rEmpleado;
	begin
		reset(arc_empleado);
		seek(arc_empleado, filesize(arc_empleado)); //deja el puntero al final del archivo
		writeln('Para dejar de cargar empleados, ingrese <fin> como apellido');
		leer(e);
		while e.apellido<>'fin' do begin
			write(arc_empleado,e);
			leer(e);
		end;
		close(arc_empleado);
	end;

procedure modificarEdad(var arc_empleado: fEmpleado); 
	var
		e:rEmpleado;
		num:integer;
		encontro:boolean;
	begin
		reset(arc_empleado);
		writeln('Ingrese num de empleado a modificar edad. Finalice con el numero -1');
		readln(num);
		while (num<>-1 ) do begin
			//busqueda del empleado
			encontro:=false;
			while (not eof(arc_empleado)) and  (not encontro) do begin //busca el empleado por numero
				read(arc_empleado,e);
				if e.num = num then encontro:=true;
			end;
			if encontro then begin //pide input de la nueva edad y modifica al empleado
				writeln('Ingrese edad modificada para el empleado ',e.nombre);
				readln(e.edad);
				seek(arc_empleado,filepos(arc_empleado)-1);
				write(arc_empleado,e);
			end
			else writeln('No existe el empleado con num ',num);
			writeln('Ingrese num de empleado a modificar edad. Finalice con el numero -1');
			readln(num);
			seek(arc_empleado,0);
		end;
		close(arc_empleado);
	end;

procedure exportarTodos(var arc_empleado:fEmpleado; var arc_text:text);
	//Se puede hacer el assign del texto directamente adentro y text variable local
var
		e:rEmpleado;
	begin
		reset(arc_empleado);
		rewrite(arc_text);
		while not eof(arc_empleado) do begin
			read(arc_empleado,e);
			with e do begin
				//writeln(arc_text,'  ',num,'  ',apellido,'  ',nombre,'  ',edad,'  ',dni);
				writeln(arc_text,num);
				writeln(arc_text,apellido,'  ',nombre);
				writeln(arc_text,edad,'  ',dni);
			end;
		end;
		close(arc_empleado);
		close(arc_text);
	end;

procedure exportarSinDni(var arc_empleado:fEmpleado; var arc_text_dni:text);
	var
		e:rEmpleado;
	begin
		reset(arc_empleado);
		rewrite(arc_text_dni);
		while not eof(arc_empleado) do begin
			read(arc_empleado,e);
			if e.dni=0 then
				with e do begin
					writeln(arc_text_dni,num);
					writeln(arc_text_dni,apellido,'  ',nombre);
					writeln(arc_text_dni,edad,'  ',dni);
				end;
		end;		
		close(arc_empleado);
		close(arc_text_dni);
	end;

var
	arc_empleado: fEmpleado;
	arc_text,arc_text_dni: text;
	nombre_archivo: str;
	opcion_elegida:char;
	
	//test
	e:rEmpleado;
	//---
begin
	writeln('Ingrese nombre del archivo: ');
	readln(nombre_archivo);
	assign(arc_empleado,nombre_archivo);
	assign(arc_text,'todos_empleados.txt');
	assign(arc_text_dni,'faltaDNIEmpleado.txt');
	writeln('Ingrese 1 si desea crear un nuevo archivo con ese nombre');
	writeln('Ingrese 2 si desea abrir un archivo con ese nombre mostrando los datos');
	writeln('Ingrese 3 para añadir uno o mas empleados al final del archivo');
	writeln('Ingrese 4 para modificar edad a uno o más empleados.');
	writeln('Ingrese 5 para exportar el contenido del archivo a un archivo de texto llamado todos_empleados.txt.');
	writeln('Ingrese 6 para exportar a un archivo de texto llamado: faltaDNIEmpleado.txt, los empleados que no tengan cargado el DNI (DNI en 00).');
	readln(opcion_elegida);
	{
	//test
	reset(arc_text);
	while not eof(arc_text) do begin
		with e do begin
			readln(arc_text,num);
			readln(arc_text,apellido);
			readln(arc_text,edad,dni);
		end;
		with e do
			writeln(num,apellido,edad,dni);
	end;
	close(arc_text);
}
	
	


	
	case opcion_elegida of
		'1': crear(arc_empleado);
		'2': mostrarDatos(arc_empleado);
		'3': anadirAlFinal(arc_empleado);
		'4': modificarEdad(arc_empleado);
		'5': exportarTodos(arc_empleado,arc_text);
		'6': exportarSinDni(arc_empleado,arc_text_dni);
		else writeln('Opcion incorrecta');
	end;
	
}
	{if (opcion_elegida=1)then begin
		crear(arc_empleado);
	end
	else if (opcion_elegida=2) then begin
		mostrarDatos(arc_empleado);
	end
	else writeln('Opcion incorrecta');
	* }
end.
