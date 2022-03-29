{
3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.

De cada producto se almacena:
código del producto, nombre, descripción, stock disponible, stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. 
Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo maestro.

La información que se recibe en los detalles es: código de producto y cantidad vendida.

Además, se deberá informar en un archivo de texto: 
nombre de producto, descripción, stock disponible y precio de aquellos productos que tengan stock disponible por debajo del stock mínimo.

Nota: todos los archivos se encuentran ordenados por código de productos. 
En cada detalle puede venir 0 o N registros de un determinado producto.
}
program ejercicio2_3;
const
	cantSuc=30;

type
	stri= string[20];
	rMaestro=record
		cod:integer;
		nombre:stri;
		stockDisp:integer;
		stockMin:integer;
		precio:real;
		descripcion:stri;
	end;

	rDetalle=record
		cod:integer;
		cantVend:integer;
	end;
	
	fMaestro = file of rMaestro;
	fDetalle = file of rDetalle;
	
	vDetalle= array [1..cantSuc] of rDetalle;
	vSucursales= array [1..cantSuc] of fDetalle;
	
procedure leer(var arc_det: fDetalle; var r:rDetalle);
	begin
		if not eof(arc_det) then
			read(arc_det,r)
		else
			r.cod:=9999;
	end;

procedure minimo(var vD:vDetalle; var min:rDetalle; var vS:vSucursales);
	var
		minI,i:integer;
	begin
		minI:=-1;
		min.cod:=9999;
		for i:=1 to cantSuc do begin
			if vD[i].cod<>9999 then begin //si no esta vacio
				if vD[i].cod <= min.cod then begin
					minI:=i;
					min.cod:=vD[i].cod;
				end;
			end;
		end;
		if minI<>-1 then begin
			min:= vD[minI];
			leer(vS[minI],vD[minI]); //avanzo al siguente elemento de la sucursal leida y lo guardo en el vector de registros
		end;
	end;

procedure actualizar(var arc_mae:fMaestro;var vS:vSucursales);
	var
		i:integer;
		vD:vDetalle;
		min:rDetalle;
		rM:rMaestro;
	begin
		for i:=1 to cantSuc do begin //abre cada archivo detalle y guarda el primer reg en el vector (si esta vacio en el cod guarda 9999)
			reset(vS[i]);
			leer(vS[i],vD[i]);
		end;
		reset(arc_mae);
	//busco el registro con el cod mas chico y lo devuelvo en min
	//si no quedan reg por leer en la sucursales, devuelve 9999 en el cod
		minimo(vD,min,vS); 
		while min.cod<>9999 do begin
			read(arc_mae,rM);
			while rM.cod<>min.cod do //busco en el archivo maestro el registro que coincida con el codigo
				read(arc_mae,rM);
			while (rM.cod=min.cod) do begin 
				rM.stockDisp:= rM.stockDisp - min.cantVend;
				minimo(vD,min,vS);
			end;
			seek(arc_mae,filepos(arc_mae)-1);
			write(arc_mae,rM);
		end;
		for i:=1 to cantSuc do 
			close(vS[i]);
		close(arc_mae);
	end;


{Además, se deberá informar en un archivo de texto: 
nombre de producto, descripción, stock disponible y precio de aquellos productos que tengan stock disponible por debajo del stock mínimo.}
procedure informar(var arc_mae:fMaestro);
	var
		arc_text:text;
		r:rMaestro;
	begin
		assign(arc_text,'prodDebajoMin.txt');
		reset(arc_mae);
		while not eof(arc_mae) do begin
			read(arc_mae,r);
			if r.stockDisp < r.stockMin then begin
				writeln(arc_text,r.stockDisp,' ',r.precio:2:2,' ',r.descripcion);
				writeln(arc_text,r.nombre);
			end;
		end;
		close(arc_text);
		close(arc_mae);
	end;

var
	v:vSucursales;
	arc_mae:fMaestro;
	i:integer;
	cad:stri;
begin
	//hago el assign de los 30 detalles
	for i:=1 to cantSuc do begin
		Str(i,cad);
		assign(v[i],Concat('det',cad));
	end;
	assign(arc_mae,'productos');
	actualizar(arc_mae,v);
	informar(arc_mae);

end.
