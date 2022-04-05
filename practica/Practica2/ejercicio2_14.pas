{14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus próximos vuelos.

En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la cantidad de asientos disponibles.

La empresa recibe todos los días dos archivos detalles para actualizar el archivo maestro.

En dichos archivos se tiene destino, fecha, hora de salida y cantidad de asientos comprados.
Se sabe que los archivos están ordenados por destino más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro.

Se pide realizar los módulos necesarios para:

c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje sin asiento disponible.
d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que tengan menos de una cantidad específica de asientos disponibles.
 La misma debe ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program ejercicio2_14;
const
	CANT_DET=2;
	VALOR_ALTO='ZZZZZ';
type
	str=string[20];
	rMaestro=record
		destino:str;
		fecha:longint;
		hora:integer;
		cantDisp:integer;
	end;
	rDetalle=record	
		destino:str; //ordenado
		fecha:longint; //ordenado
		hora:integer; //ordenado
		cantCompr:integer;
	end;
	
	fMaestro=file of rMaestro;
	fDetalle=file of rDetalle;
	
	vDetalles= array[1..CANT_DET] of fDetalle;
	vRegistros= array [1..CANT_DET] of rDetalle;

procedure leer(var arc_det:fDetalle; var r:rDetalle);
	begin
		if not eof(arc_det) then
			read(arc_det,r)
		else
			r.destino:=VALOR_ALTO;
	end;

procedure minimo(var vDet:vDetalles; var vReg:vRegistros; var min:rDetalle);
	var
		minI,i:integer;
	begin
		minI:=-1;
		min.destino:=VALOR_ALTO;
		for i:=1 to CANT_DET do begin
			if vReg[i].destino<>VALOR_ALTO then begin //si no esta vacio
				if (vReg[i].destino < min.destino) or 
				((vReg[i].destino=min.destino) and (vReg[i].fecha < min.fecha)) or 
				((vReg[i].destino=min.destino) and (vReg[i].fecha = min.fecha) and ( vReg[i].hora < min.hora)) then begin
					minI:=i;
					min.destino:=vReg[i].destino;
				end
			end;
		end;
		if minI<>-1 then begin
			min:= vReg[minI];
			leer(vDet[minI],vReg[minI]); //avanzo al siguente elemento de la sucursal leida y lo guardo en el vector de registros
		end;
	end;

procedure actualizar(var vDet:vDetalles);
	var
		i:integer;
		vReg:vRegistros;
		min:rDetalle;
		rMae:rMaestro;
		arc_mae:fMaestro;
	begin
		for i:=1 to CANT_DET do begin
			reset(vDet[i]);
			leer(vDet[i],vReg[i]);
		end;
		assign(arc_mae,'maestro.dat');
		reset(arc_mae);
		minimo(vDet,vReg,min);
		while min.destino<>VALOR_ALTO do begin
			read(arc_mae,rMae);
			while (rMae.destino<>min.destino) or (rMae.fecha<>min.fecha) or (rMae.hora<>min.hora) do
				read(arc_mae,rMae);
			while ((rMae.destino=min.destino) and (rMae.fecha=min.fecha)and (rMae.hora=min.hora)) do begin 
				rMae.cantDisp:=rMae.cantDisp - min.cantCompr;
				minimo(vDet,vReg,min);
			end;
			seek(arc_mae,filepos(arc_mae)-1);
			write(arc_mae,rMae);		
		end;
		
		for i:=1 to CANT_DET do 
			close(vDet[i]);	
		close(arc_mae);
	end;

var
	vDet:vDetalles;
	
begin
	actualizar(vDet);

end.
