{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con la información correspondiente a las prendas que se encuentran a la venta.

De cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y precio_unitario.

Ante un eventual cambio de temporada, se deben actualizar las prendas a la venta. 
Para ello reciben un archivo conteniendo: cod_prenda de las prendas que quedarán obsoletas.

Deberá implementar un procedimiento que reciba ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.

Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas compactando el archivo.

Para ello se deberá utilizar una estructura auxiliar, renombrando el archivo original al finalizar el proceso.. 
Solo deben quedar en el archivo las prendas que no fueron borradas, una vez realizadas todas las bajas físicas.
}
program ejercicio3_6;
const
	VALOR_ALTO = 9999;
type
	str = string[20];
	rPrenda= record
		cod:integer;
		descripcion:str;
		colores:str;
		tipo_prenda:str;
		stock:integer;
		precio_unitario:real;
	end;
	
	fPrendas = file of rPrenda;
	fPrendasObsoletas = file of integer; //codigo de prendas obsoletas

	
procedure leerBaja(var arc_bajas:fPrendasObsoletas; var cod:integer);
	begin
		if not eof(arc_bajas) then
			read(arc_bajas,cod)
		else
			cod:= VALOR_ALTO;
	end;

procedure leerPrenda(var arc_prendas:fPrendas; var r:rPrenda);
	begin
		if not eof(arc_prendas) then 
			read(arc_prendas,r)
		else
			r.cod:= VALOR_ALTO;
	end;
{Deberá implementar un procedimiento que reciba ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.}
procedure bajasLogicas(var arc_prendas:fPrendas; var arc_bajas:fPrendasObsoletas);
	var
		r:rPrenda;
		codBaja:integer;
	begin
		reset(arc_prendas);
		reset(arc_bajas);
		
		leerBaja(arc_bajas,codBaja);
		while codBaja<>VALOR_ALTO do begin
			//buscar prenda en el archivo no ordenado(desde la primer posicion y marcar)
			leerPrenda(arc_prendas,r);
			while (r.cod<>codBaja) and (r.cod<>VALOR_ALTO) do //busca la prenda a dar de baja
				leerPrenda(arc_prendas,r);
			if r.cod<>VALOR_ALTO then begin //si encontro la prenda la vuelve a guardar
				r.stock:= r.stock * (-1); //  hace negativo al stock 
				seek(arc_prendas,filepos(arc_prendas)-1); //vuelve un lugar atras
				write(arc_prendas,r); //reemplaza con el stock negativo
			end;
			
			seek(arc_prendas,0); //vuelve al inicio
			leerBaja(arc_bajas,codBaja);			
		end;
		close(arc_prendas);
		close(arc_bajas);
	end;


procedure compactar(var arc_prendas:fPrendas);
	var
		arc_nuevo:fPrendas;
		r:rPrenda;
	begin
		assign(arc_nuevo,'prendas_nuevo.dat');
		rewrite(arc_nuevo);
		reset(arc_prendas);
		while not eof(arc_prendas) do begin
			read(arc_prendas,r);
			if r.stock>=0 then //si el stock no es negativo escribo el dato
				write(arc_nuevo,r);
		end;
		close(arc_prendas);
		close(arc_nuevo);
	end;
		
var
	arc_prendas:fPrendas;
	arc_bajas: fPrendasObsoletas;
begin
	bajasLogicas(arc_prendas,arc_bajas);
	compactar(arc_prendas);


end.
