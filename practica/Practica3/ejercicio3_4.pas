{4. Dada la siguiente estructura:
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:

(Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descripta anteriormente)
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.

5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:

(Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente)
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);

}
program ejercicio3_4;
const
	VALOR_ALTO=9999;
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;

procedure agregarFlor (var archivo: tArchFlores ; nombre: string; codigo:integer);
	var
		r,rCab:reg_flor;
	begin
		reset(archivo);
		r.nombre:=nombre;
		r.codigo:=codigo;
		read(archivo,rCab); //leo el registro cabecera
		if rCab.codigo=0 then begin //no hay espacio para reutilizar, voy al final y escribo el elemento
				seek(archivo,filesize(archivo));
				write(archivo,r);
		end
		else begin
			rCab.codigo:=rCab.codigo * (-1); //paso a positivo el indice
			seek(archivo,rCab.codigo); //mover a la posicion indice que tiene el reg cabecera
			read(archivo,rCab);		//guardo el valor que se encuentra en esa posicion 
			seek(archivo,filepos(archivo) -1); //vuelvo un lugar atras por la lectura anterior
			write(archivo,r);//escribo el dato nuevo en esa posicion
			seek(archivo,0);//vuelvo a cabecera
			write(archivo,rCab); //escribo el nuevo indice en cabecera
		end;
		close(archivo);
	end;

{b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}
procedure listarContenido(var archivo: tArchFlores);
	var
		r:reg_flor;
	begin
		reset(archivo);
		read(archivo,r); //descarta reg cabecera
		while not eof(archivo) do begin
			read(archivo,r);
			if r.codigo>0 then begin
				writeln('Codigo de flor: ',r.codigo,' ,nombre: ',r.nombre);
			end;
		end;
		close(archivo);
	end;

procedure leerArchivo(var archivo: tArchFlores; var r:reg_flor);
	begin
		if not eof(archivo) then
			read(archivo,r)
		else
			r.codigo:= VALOR_ALTO;
	end;


{(Abre el archivo y elimina la flor recibida como parámetro manteniendo la política descripta anteriormente)
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}
procedure eliminarFlor (var archivo: tArchFlores; flor:reg_flor);
	var
		r,rCab:reg_flor;
	begin
		reset(archivo);
		read(archivo,rCab); // leo y guardo cabecera 
		leerArchivo(archivo,r);
		while (r.codigo<>VALOR_ALTO) and (r.nombre<>flor.nombre) do  //busco elemento a borrar 
			leerArchivo(archivo,r);
		if r.nombre=flor.nombre then begin
			seek(archivo,(filepos(archivo) - 1)); //vuelvo un lugar atras
			r.codigo:= filepos(archivo) * (-1); //guardo nrr en r y lo pasaso a negativo * (-1)
			write(archivo,rCab);//	escribo el reg cabecera en la posicion donde estaba x
			seek(archivo,0);//	voy a cabecera
			write(archivo,r)//	escribo el reg con el nrr en cabecera
		end
		else
			writeln('No existe la flor a eliminar');
		close(archivo);
	end;
	
