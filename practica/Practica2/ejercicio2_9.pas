{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:

Código de Provincia

Código de Localidad		 Total de Votos
...................      ..............
..................       ..............
Total de Votos Provincia: ____


Código de Provincia

Código de Localidad		 Total de Votos
...................      ..............
..................       ..............
Total de Votos Provincia: ____

.......................................

Total General de Votos: ___

NOTA: La información se encuentra ordenada por código de provincia y código de
localidad.
}
program ejercicio2_9;

const
	VALOR_ALTO=9999;

type


	rMesa=record
		nro:integer;
		codProv:integer;
		codLoc:integer;
		cant:integer;
	end;

	fMesas=file of rMesa;
	
procedure leer(var arc_mesas:fMesas; var r:rMesa);
	begin
		if not eof(arc_mesas) then
			read(arc_mesas,r)
		else
			r.codProv:=VALOR_ALTO;
	end;

procedure imprimirListado(var arc_mesas:fMesas);
	var
		r:rMesa;
		codProvAct,codLocAct,cantProv,cantLoc,cantTotal:integer;
	begin
		reset(arc_mesas);
		cantTotal:=0;
		leer(arc_mesas,r);
		while r.codProv<>VALOR_ALTO do begin
			codProvAct:=r.codProv;
			cantProv:=0;
			writeln('Codigo de Provincia: ');
			writeln(codProvAct);
			writeln('Codigo de localidad		Total votos ');
			while r.codProv=codProvAct do begin
				codLocAct:=r.codLoc;
				cantLoc:=0;
				writeln(r.codLoc);
				while (r.codProv=codProvAct) and
					(r.codLoc=codLocAct) do begin
					cantLoc:=cantLoc+r.cant;
					leer(arc_mesas,r);
				end;
				writeln(codLocAct,'				  ',cantLoc);
			end;
			writeln('Total de Votos Provincia: ',cantProv);
		end;
		writeln('Total General de Votos: ',cantTotal);
	end;
var
	arc_mesas: fMesas;
begin
	assign(arc_mesas,'mesas.data');
	imprimirListado(arc_mesas);
end.
