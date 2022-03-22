{
7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.
* }
program ejercicio1_7;

type 
	str=string[20];
	rNovela= record
		cod:integer;
		precio:real;
		genero:str;
		nombre:str;
	end;
	
	fNovela= file of rNovela;
	
procedure leer(var r:rNovela);
	begin
		write('cod: ');readln(r.cod);
		write('precio: '); readln(r.precio);
		write('genero: '); readln(r.genero);
		write('nombre: '); readln(r.nombre);
	end;
procedure crearArchivo(	var arc_novela:fNovela;var arc_text:text);
	var
		r:rNovela;
	begin
		assign(arc_text,'novelas.txt');
		rewrite(arc_novela);
		reset(arc_text);
		while not eof(arc_text) do begin
			readln(arc_text,r.cod,r.precio,r.genero);
			readln(arc_text,r.nombre);
			write(arc_novela,r);
			writeln(r.cod,' ',r.precio,' ',r.genero,' ',r.nombre);
		end;
		close(arc_novela);
		close(arc_text);
	end;
	
procedure agregarNovela(var arc_novela:fNovela);
	var
		r:rNovela;
	begin
		reset(arc_novela);
		seek(arc_novela,filesize(arc_novela));
		leer(r);
		write(arc_novela,r);
		close(arc_novela);
	end;
	
procedure modificarNovela(var arc_novela:fNovela);
	var
		cod:integer;
		r:rNovela;
		encontro: boolean;
	begin
		reset(arc_novela);
		writeln('-------------------------');
		writeln('Ingrese el cod de novela a modificar, finalice con -1');
		readln(cod);
		while cod<>-1 do begin
			encontro:=false;
			while (not eof(arc_novela)) and not encontro do begin
				read(arc_novela,r);
				if r.cod=cod then encontro:=true;
			end;
			if encontro then begin
				writeln('--Datos nuevos:');
				leer(r); //lee los nuevos datos de la novela
				seek(arc_novela,filepos(arc_novela)-1); //retrocede un lugar porque quedo delante de la novela a modificar
				write(arc_novela,r);
			end
			else writeln('Codigo de novela inexistente');
			
			seek(arc_novela,0); //va al principio del archivo
			writeln('Ingrese el cod de novela a modificar, finalice con -1');
			readln(cod);
		end;
	
	end;
{b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.}
procedure actualizar(var arc_novela:fNovela);
	var
		opcion:char;
	begin
		writeln('---------------');
		writeln('Ingrese 1 para agregar una novela');
		writeln('Ingrese 2 para modificar una novela existente');
		writeln('Ingrese 0 para volver al menu principal');
		writeln('---------------');
		readln(opcion);
		while opcion<>'0' do begin
			case opcion of
				'1': agregarNovela(arc_novela);
				'2': modificarNovela(arc_novela);
				else writeln('Opcion incorrecta');
			end;
			writeln('---------------');
			writeln('Ingrese 1 para agregar una novela');
			writeln('Ingrese 2 para modificar una novela existente');
			writeln('Ingrese 0 para volver al menu principal');
			writeln('---------------');
			readln(opcion);
		end;
	end;

procedure menuPrincipal(var arc_novela:fNovela; var arc_text:text);
	var
		opcion:char;
	begin
		writeln('Ingrese 1 si desea crear un archivo binario a partir de la información almacenada en un archivo de texto.');
		writeln('Ingrese 2 si desea abrir el archivo binario y permitir la actualización del mismo.');
		writeln('Ingrese 0 si desea salir.');
		readln(opcion);
		while opcion <> '0' do begin
			case opcion of
				'1': crearArchivo(arc_novela,arc_text);
				'2': actualizar(arc_novela);
				else writeln('Opcion incorrecta');
			end;
		writeln('Ingrese 1 si desea crear un archivo binario a partir de la información almacenada en un archivo de texto.');
		writeln('Ingrese 2 si desea abrir el archivo binario y permitir la actualización del mismo.');
		writeln('Ingrese 0 si desea salir.');
		readln(opcion);
		end;
	end;

var
	arc_novela:fNovela;
	arc_text:text;


begin
	
	assign(arc_novela,'Novela');
	menuPrincipal(arc_novela,arc_text);

end.
