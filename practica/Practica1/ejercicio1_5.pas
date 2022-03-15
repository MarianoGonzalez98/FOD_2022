{

5. Realizar un programa para una tienda de celulares, que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripcion, marca, precio, stock mínimo y el stock disponible.

b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
una única vez.
 
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”
}
program ejercicio1_5;
type
	str=string[15];
	str2=string[30];
	rCelular=record
		cod:integer;
		precio:real;
		marca:str;
		stockDisp:integer;
		stockMin:integer;
		desc:str2;
		nombre:str;
	end;
	fCelulares=file of rCelular;
	
procedure crearDesdeTxt(var arc_file:fCelulares; var arc_text:text);
	var
		r:rCelular;
	begin
		rewrite(arc_file);
		reset(arc_text);
		while not eof(arc_text) do begin
			with r do begin
				readln(arc_text,cod,precio,marca);
				readln(arc_text,stockDisp,stockMin,desc);
				readln(arc_text,nombre);
			end;
			write(arc_file,r);
			with r do
				writeln(cod,' ',precio,' ',marca,' ',stockDisp,' ',stockMin,' ',desc,' ',nombre); //imprime lo que se escribe en el arch
		end;
		
		close(arc_file);
		close(arc_text);
	end;
//b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
procedure listarStockMenor(var arc_file:fCelulares);
	var
		r:rCelular;
	begin
		reset(arc_file);
		writeln('Datos de aquellos celulares que tengan un stock menor al stock mínimo:');
		while not eof(arc_file) do begin
			read(arc_file,r);
			if r.stockDisp < r.stockMin then 
				with r do
					writeln(cod,' ',precio,' ',marca,' ',stockDisp,' ',stockMin,' ',desc,' ',nombre);
		end;
		close(arc_file);
	end;


//c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
procedure listarPorDescripcion(var arc_file:fCelulares);
	var
		r:rCelular;
		cad:str2;
	begin
		reset(arc_file);
		writeln('Celulares del archivo cuya descripción contenga la siguiente cadena: (tipear cadena)');
		readln(cad);
		while not eof(arc_file) do begin
			read(arc_file,r);
			if cad=r.desc then 
				with r do
					writeln(cod,' ',precio,' ',marca,' ',stockDisp,' ',stockMin,' ',desc,' ',nombre);
		end;
		
		close(arc_file);
	end;

procedure exportarTxt(var arc_file:fCelulares; var arc_text:text);
	begin
	
	end;

var
	arc_file:fCelulares;
	arc_text:text;
	nombreArc:str;
	opcion:char;
begin
	write('Ingrese el nombre del archivo de celulares: '); readln(nombreArc);
	assign(arc_file,nombreArc);
	assign(arc_text,'celulares.txt');

	writeln('1 para crear un archivo de registros de celulares a partir de un txt de celulares');
	writeln('2 para listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.');
	writeln('3 para listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.' );
	writeln('4 para Exportar el archivo de registros a un archivo de texto “celulares.txt” con todos los celulares del mismo');
	readln(opcion);
	
	case opcion of
		'1': crearDesdeTxt(arc_file,arc_text);
		'2': listarStockMenor(arc_file);
		'3': listarPorDescripcion(arc_file);
		'4': exportarTxt(arc_file,arc_text);
		else writeln('Opcion incorrecta');
	end;
end.
