{5 detalles

acumular tiempo de sesiones

corte de control de fecha?

fecha: longint;
		
assign (arc,/var/log.)
}

{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). 
La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las máquinas se conectan con un servidor central.
Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. 

Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. 

Debe realizar un procedimiento que reciba los archivos detalle y genere un archivo maestro con los siguientes datos:
cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}

program ejercicio2_4;
const
	cantMaq=30;
	VALOR_ALTO=9999;
type
	str=string[20];
	rUsuario=record
		cod:integer;
		fecha:longint;
		tiempo:integer;
	end;
	
	fUsuarios= file of rUsuario;
	vDetalles= array[1..cantMaq] of fUsuarios;
	vUsuarios= array[1..cantMaq] of rUsuario;

procedure leer(var arc_det: fUsuarios; var r:rUsuario);
	begin
		if not eof(arc_det) then
			read(arc_det,r)
		else
			r.cod:=VALOR_ALTO;
	end;

procedure minimo(var vD:vDetalles; var vR:vUsuarios; var min:rUsuario);
	var
		minI,i:integer;
	begin
		minI:=-1;
		min.cod:=VALOR_ALTO;
		for i:=1 to cantMaq do begin
			if vR[i].cod<>VALOR_ALTO then begin //si no esta vacio
				if (vR[i].cod < min.cod) or ((vR[i].cod=min.cod) and (vR[i].fecha < min.fecha)) then begin
					minI:=i;
					min.cod:=vR[i].cod;
				end
			end;
		end;
		if minI<>-1 then begin
			min:= vR[minI];
			leer(vD[minI],vR[minI]); //avanzo al siguente elemento de la sucursal leida y lo guardo en el vector de registros
		end;
	end;
{Debe realizar un procedimiento que reciba los archivos detalle y genere un archivo maestro con los siguientes datos:
cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.}
procedure actualizar(var vD:vDetalles);
	var
		i:integer;
		vR:vUsuarios;
		min:rUsuario;
		rM:rUsuario;
		arc_mae:fUsuarios;
	begin
		for i:=1 to cantMaq do begin
			reset(vD[i]);
			leer(vD[i],vR[i]);
		end;
		assign(arc_mae,'/var/log/maestro.dat');
		rewrite(arc_mae);
		minimo(vD,vR,min);
		while min.cod<>VALOR_ALTO do begin
			rM:=min;
			rM.tiempo:=0;
			while ((rM.cod=min.cod)and(rM.fecha=min.fecha)) do begin 
				rM.tiempo:=rM.tiempo + min.tiempo;
				minimo(vD,vR,min);
			end;
			seek(arc_mae,filepos(arc_mae)-1);
			write(arc_mae,rM);		
		end;
		
		for i:=1 to cantMaq do 
			close(vD[i]);	
	end;
		

