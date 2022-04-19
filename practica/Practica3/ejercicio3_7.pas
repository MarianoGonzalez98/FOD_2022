{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}

program ejercicio3_7;
const
	VALOR_ALTO=9999;
type
	str=string[20];
	rEspecie=record
		cod:integer;
		nombre:str;
		familia:str;
		descripcion:str;
		zona:str;
	end;
	fEspecies= file of rEspecie;


//procedimiento que marca los registros a borrar, recibiendo por teclado las especies a eliminar.
//elimino asignando "***" en el nombre;

procedure leer(var arc_especies:fEspecies; var r:rEspecie);
	begin
		if not eof(arc_especies) then 
			read(arc_especies,r)
		else
			r.cod:=VALOR_ALTO;
	end;

procedure marcarParaEliminar(var arc_especies:fEspecies);
	var
		r:rEspecie;
		cod:integer;
	begin
		reset(arc_especies);
		write('Ingrese cod de especie a eliminar, finalice con 5000:  ');
		readln(cod);
		
		while cod<>5000 do begin //busca la especie por cod y la marca
			leer(arc_especies,r);
			while (r.cod<>VALOR_ALTO) and (r.cod <> cod) do
				leer(arc_especies,r);
			if r.cod = cod then begin //encontro la especie
				r.nombre:='***';
				seek(arc_especies,filepos(arc_especies)-1); //vuelvo un lugar atras
				write(arc_especies,r); //sobreescribo con el campo nombre marcado
			end
			else
				writeln('No existe la especie');
			seek(arc_especies,0); //vuelvo al primer registro por si vuelvo a iterar
			write('Ingrese cod de especie a eliminar, finalice con 5000:  ');
			readln(cod);
		end;
		close(arc_especies);
	end;
{compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.}

procedure compactarTruncando(var arc_especies: fEspecies); //reevisar lo hice rapido xd
	var
		cantReg,actual:integer;
		r,rUltimo:rEspecie;
	begin
		reset(arc_especies);
		actual:=0;
		cantReg:= filesize(arc_especies); //guardo la cantidad total para disminuirla al ir borrando
		while actual<cantReg do begin
			leer(arc_especies,r);
			if r.nombre= '***' then begin // cambiar registro con el ultimo dato (no eliminado)
				seek(arc_especies,cantReg - 1); //voy al ultimo dato no eliminado
				read(arc_especies,rUltimo); //copio el ultimo dato no eliminado
				seek(arc_especies,cantReg - 1); //vuelvo un lugar atras
				write(arc_especies,r); //sobreescribo el ultimo dato con el borrado
				cantReg := cantReg - 1; //disminuyo en uno el total de datos
				seek(arc_especies,actual); //vuelvo a la ubicacion donde estaba el dato a eliminar
				write(arc_especies,r); //escribo el ultimo dato 
				//no incremento actual porque necesito analizar este dato
			end
			else //no se debe eliminar el dato
				actual := actual + 1; //incremento actual
		end;
		close(arc_especies)
	end;


var
	arc_especies:fEspecies;
begin
	assign(arc_especies,'especies.dat');
	marcarParaEliminar(arc_especies);
	compactarTruncando(arc_especies);

end.
