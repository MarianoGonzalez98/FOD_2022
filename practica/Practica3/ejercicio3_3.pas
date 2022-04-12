{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente año.
De cada novela se registra: código, género, nombre, duración, director y precio. 
El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. 
Se utiliza la técnica de lista invertida para recuperar espacio libre en el archivo.
Para ello, durante la creación del archivo, en el primer registro del mismo se debe almacenar la cabecera de la lista. 
Es decir un registro ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela,
	el cual indica que no hay espacio libre dentro del archivo.
	
	
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el inciso a.,
	se utiliza lista invertida para recuperación de espacio. 
En particular, para el campo de ´enlace´ de la lista, se debe especificar los números de registro referenciados con signo negativo,
(utilice el código de novela como enlace).Una vez abierto el archivo, brindar operaciones para:

	i. Dar de alta una novela leyendo la información desde teclado. Para esta operación, en caso de ser posible, deberá recuperarse el espacio libre.
	 Es decir, si en el campo correspondiente al código de novela del registro cabecera hay un valor negativo, por ejemplo -5, 
		se debe leer el registro en la posición 5, copiarlo en la posición 0 (actualizar la lista de espacio libre) y grabar el nuevo registro en la posición 5.
	Con el valor 0 (cero) en el registro cabecera se indica que no hay espacio libre.

	ii. Modificar los datos de una novela leyendo la información desde teclado. El código de novela no puede ser modificado.
	iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8, 
		en el campo código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera.
}
program ejercicio3_3;
type 
	str=string[20];
	rNovela=record
		cod:integer;
		//gen:str;
		nombre:str;
		//duracion:integer;
		//director:str;
		//precio:real;
	end;
	
	fNovelas=file of rNovela;
	
procedure leerDatos(var r:rNovela);
	begin
		write('-----Codigo de novela: '); readln(r.cod);
		if r.cod<>-1 then begin
			//write('genero: '); readln(r.gen);
			write('nombre: '); readln(r.nombre);
			//write('duracion: '); readln(r.duracion);
			//write('director: '); readln(r.director);
			//write('precio: '); readln(r.precio);
		end;
	end;
	
{
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. 
Se utiliza la técnica de lista invertida para recuperar espacio libre en el archivo.
Para ello, durante la creación del archivo, en el primer registro del mismo se debe almacenar la cabecera de la lista. 
Es decir un registro ficticio, inicializando con el valor cero (0) el campo correspondiente al código de novela,
	el cual indica que no hay espacio libre dentro del archivo.
}

procedure crearArchivo(var arc_novela:fNovelas);
	var
		r:rNovela;
	begin
		rewrite(arc_novela);
		r.cod:=0;
		write(arc_novela,r); //inicializo la cabecera de lista en 0
		leerDatos(r);
		while r.cod<>-1 do begin
			write(arc_novela,r);
			leerDatos(r);
		end;
		close(arc_novela);
	end;

procedure alta(var arc_novela:fNovelas);
	var
		rCab,r:rNovela;
	begin
		leerDatos(r); 
		read(arc_novela,rCab); //leo el registro cabecera
		if rCab.cod=0 then begin //no hay espacio para reutilizar, voy al final y escribo el elemento
			seek(arc_novela,filesize(arc_novela));
			write(arc_novela,r);
		end
		else begin
			rCab.cod:=rCab.cod * (-1); //paso a positivo el indice
			seek(arc_novela,rCab.cod); //mover a la posicion indice que tiene el reg cabecera
			read(arc_novela,rCab);		//guardo el valor que se encuentra en esa posicion 
			seek(arc_novela,filepos(arc_novela) -1); //vuelvo un lugar atras por la lectura anterior
			write(arc_novela,r);//escribo el dato nuevo en esa posicion
			seek(arc_novela,0);//vuelvo a cabecera
			write(arc_novela,rCab); //escribo el nuevo indice en cabecera
		end;
	end;
	
	{ii. Modificar los datos de una novela leyendo la información desde teclado. El código de novela no puede ser modificado.} //existe?
procedure modificar(var arc_novela:fNovelas);
	var
		r,aux:rNovela;
	begin
		writeln('Ingrese datos de la novela a modificar');
		leerDatos(r);
		read(arc_novela,aux);
		while r.cod<>aux.cod do //busco la novela con el codigo correspondiente
			read(arc_novela,aux);
		seek(arc_novela,filepos(arc_novela)-1);
		write(arc_novela,r);
	end;

{	iii. Eliminar una novela cuyo código es ingresado por teclado. Por ejemplo, si se da de baja un registro en la posición 8, 
		en el campo código de novela del registro cabecera deberá figurar -8, y en el registro en la posición 8 debe copiarse el antiguo registro cabecera.}
		//existe?
procedure eliminar(var arc_novela:fNovelas);
	var
		cod:integer;
		rCab,r:rNovela;
	begin
		write('Ingrese cod de novela a eliminar: ');
		readln(cod);
		read(arc_novela,rCab); // y:= leo cabecera 
		read(arc_novela,r);
		while r.cod<>cod do  //busco elemento a borrar (x)
			read(arc_novela,r);
		r.cod:=filepos(arc_novela) * -1; //guardo nrr en r y lo pasaso a negativo * (-1)
		seek(arc_novela,(filepos(arc_novela) - 1));
		write(arc_novela,rCab);//	escribo Y en la posicion donde estaba x
		seek(arc_novela,0);//	voy a cabecera
		write(arc_novela,r)//	escribo el reg con el nrr en cabecera
	end;
procedure mantenimiento(var arc_novela: fNovelas);
	var
		opcion:char;
	begin
		reset(arc_novela);
		writeln('Ingrese 1 para dar de alta una novela leyendo la información desde teclado.');
		writeln('Ingrese 2 para modificar los datos de una novela leyendo la información desde teclado.');
		writeln('Eliminar una novela cuyo código es ingresado por teclado.');
		readln(opcion);
		case opcion of
			'1': alta(arc_novela);
			'2': modificar(arc_novela);
			'3': eliminar(arc_novela);
			else writeln('Opcion incorrecta');
		end;
		close(arc_novela);
	end;

procedure imprimirDatos(var arc_novela: fNovelas);
	var
		r:rNovela;
	begin
		reset(arc_novela);
		read(arc_novela,r); //descarto primer registro
		while not eof(arc_novela) do begin
			read(arc_novela,r);
			if r.cod>0 then
				writeln(' Cod: ',r.cod,' Nombre: ',r.nombre);
		end;
		close(arc_novela);
	end;

var
	arc_novela:fNovelas;
	opcion:char;
begin
	assign(arc_novela,'novelas.dat');
	writeln('Ingrese "a" para crear el archivo de novelas');
	writeln('Ingrese "b" para hacer mantenimiento del archivo de novelas');
	readln(opcion);
	case opcion of 
		'a': crearArchivo(arc_novela);
		'b': mantenimiento(arc_novela);
		else writeln('Opcion incorrecta');
	end;
	imprimirDatos(arc_novela);
end.
