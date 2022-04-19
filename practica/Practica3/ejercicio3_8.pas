{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux existentes. 

De cada distribución se conoce: nombre, año de lanzamiento, número de versión del kernel, cantidad de desarrolladores y descripción.
El nombre de las distribuciones no puede repetirse.

Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.

Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si la distribución existe en el archivo o falso en caso contrario.

AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la agrega al archivo reutilizando espacio disponible en caso de que exista. 
(El control de unicidad lo debe realizar utilizando el módulo anterior).
En caso de que la distribución que se quiere agregar ya exista se debe informar “ya existe la distribución”.

BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se lee por teclado.
Para marcar una distribución como borrada se debe utilizar el campo cantidad de desarrolladores para mantener actualizada la lista invertida. 
Para verificar que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion.
En caso de no existir se debe informar “Distribución no existente”.
}

program ejercicio3_8;
const
	VALOR_ALTO='ZZZZ';
type
	str=string[20];
	rDistro = record
		nombre:str;
		cant:integer;
		ano:integer;
		numVersion:integer;
		descripcion:str;
	end;
	fDistros= file of rDistro;
	
//ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si la distribución existe en el archivo o falso en caso contrario.
//El nombre de las distribuciones no puede repetirse.
function existeDistribucion(var arc_distros:fDistros ;nombre :str): boolean;
	var
		r:rDistro;
		encontro:boolean;
	begin
		encontro:=false;
		while not eof(arc_distros) and not encontro do begin
			read(arc_distros,r);
			if r.nombre=nombre then
				encontro:= true;
		end;
		seek(arc_distros,0); //reposiciono puntero al principio
		existeDistribucion:= encontro;
	end;
{AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la agrega al archivo reutilizando espacio disponible en caso de que exista. 
(El control de unicidad lo debe realizar utilizando el módulo anterior).
En caso de que la distribución que se quiere agregar ya exista se debe informar “ya existe la distribución”.}

procedure leerDatos(var r:rDistro);
	begin
		write('Ingrese nombre: '); readln(r.nombre);
		write('Ingrese cant de desarrolladores: '); readln(r.cant);
	end;

procedure altaDistribucion(var arc_distros:fDistros);
	var
		r,rCab:rDistro;
	begin
		reset(arc_distros);
		leerDatos(r);
		if not existeDistribucion(arc_distros,r.nombre) then begin
			read(arc_distros,rCab); //leo el registro cabecera
			if rCab.cant=0 then begin //no hay espacio para reutilizar, voy al final y escribo el elemento
				seek(arc_distros,filesize(arc_distros));
				write(arc_distros,r);
			end
			else begin
				rCab.cant:=rCab.cant * (-1); //paso a positivo el indice
				seek(arc_distros,rCab.cant); //mover a la posicion indice que tiene el reg cabecera
				read(arc_distros,rCab);		//guardo el valor que se encuentra en esa posicion 
				seek(arc_distros,filepos(arc_distros) -1); //vuelvo un lugar atras por la lectura anterior
				write(arc_distros,r);//escribo el dato nuevo en esa posicion
				seek(arc_distros,0);//vuelvo a cabecera
				write(arc_distros,rCab); //escribo el nuevo indice en cabecera
			end;
		end
		else
			writeln('Ya existe la distribucion');
		close(arc_distros);
	end;
	
{BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se lee por teclado.
Para marcar una distribución como borrada se debe utilizar el campo cantidad de desarrolladores para mantener actualizada la lista invertida. 
Para verificar que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion.
En caso de no existir se debe informar “Distribución no existente”.}
procedure bajaDistribucion(var arc_distros:fDistros);
	var
		r,rCab:rDistro;
		nombre:str;
		
	begin
		reset(arc_distros);
		write('Nombre de la distribucion a borrar: '); readln(nombre);
		if existeDistribucion(arc_distros,nombre) then begin
			read(arc_distros,rCab); // leo y guardo cabecera 
			read(arc_distros,r);
			while r.nombre<>nombre do  //busco elemento a borrar 
				read(arc_distros,r);
			seek(arc_distros,(filepos(arc_distros) - 1)); //vuelvo un lugar atras
			r.cant:= filepos(arc_distros) * (-1); //guardo nrr en r y lo pasaso a negativo * (-1)
			write(arc_distros,rCab);//	escribo el reg cabecera en la posicion donde estaba x
			seek(arc_distros,0);//	voy a cabecera
			write(arc_distros,r)//	escribo el reg con el nrr en cabecera
		end
		else
			writeln('No existe esa distribucion');
		close(arc_distros);
	end;
	
var
	arc_distros:fDistros;
begin
	assign(arc_distros,'distros.dat');
	altaDistribucion(arc_distros);
	bajaDistribucion(arc_distros);

end.

		
