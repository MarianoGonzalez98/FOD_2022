{10. Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras realizadas por el empleado.
Se sabe que el archivo se encuentra ordenado por departamento, luego por división, y por último, por número de empleados. 
Presentar en pantalla un listado con el siguiente formato:

Departamento

	División

	Número de Empleado 		Total de Hs		 Importe a cobrar
	......					.....			.....

	Total de horas división: ____
	Monto total por división: ____
	
	División
	Número de Empleado 		Total de Hs		 Importe a cobrar
	......					.....			.....
	
Total horas departamento: ____

Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. 
La categoría varía de 1 a 15.
En el archivo de texto debe haber una línea para cada categoría con el número de categoría y el valor de la hora,
 pero el arreglo debe ser de valores de horas, con la posición del valor coincidente con el número de categoría.
}
program ejercicio2_10;
const
	dimF=15;
	VALOR_ALTO='ZZZZ';
type
	str=string[20];
	rEmpleado=record
		depto:str;
		division:str;
		num:integer;
		cat:integer;
		cant:integer;
	end;
	
	fEmpleados=file of rEmpleado;
	vValores= array [1..dimF] of real; // valor de la hora por categoria
	
procedure leer(var arc_emple:fEmpleados; var r:rEmpleado);
	begin
		if not eof(arc_emple) then read(arc_emple,r)
		else r.depto:=VALOR_ALTO;
	end;

procedure imprimirListado(var arc_emple:fEmpleados; v:vValores);
	var
		deptoAct,divAct:str;
		cantDepto,cantDiv:integer;
		montoDepto,montoDiv,montoEmple:real;
		r:rEmpleado;
	begin
		reset(arc_emple);
		leer(arc_emple,r);
		while r.depto<>VALOR_ALTO do begin
			writeln('Departamento: ',r.depto);
			deptoAct:=r.depto;
			cantDepto:=0;
			montoDepto:=0;
			while r.depto=deptoAct do begin
				writeln('Division: ',r.division);
				writeln('Número de Empleado 		Total de Hs		 Importe a cobrar');
				divAct:=r.division;
				cantDiv:=0;
				montoDiv:=0;
				
				while (r.depto=deptoAct) and (r.division=divAct) do begin
					montoEmple:=v[r.cat]*r.cant;
					montoDiv:=montoDiv+montoEmple;
					montoDepto:=montoDepto+montoEmple;
					cantDiv:=cantDiv+r.cant;
					cantDepto:=cantDepto+r.cant;
					writeln(r.num,'				',r.cant,'			',montoEmple);
					leer(arc_emple,r);
				end;
				writeln('Total de horas división: ',cantDiv);
				writeln('Monto total por división:',montoDiv);
			end;
			writeln('Total horas departamento: ',cantDepto);
			writeln('Monto total departamento: ',montoDepto);
		end;
		close(arc_emple);
	end;

procedure cargarArreglo(var v:vValores);
	var
		arc_text:text;
		valor:real;
		i:integer;
	begin
		assign(arc_text,'valores.txt');
		reset(arc_text);
		for i:=1 to dimF do begin
			readln(arc_text,valor);
			v[i]:=valor;
		end;
		close(arc_text);
	end;

var
	v:vValores;
	arc_emple:fEmpleados;

begin
	cargarArreglo(v);
	assign(arc_emple,'empleados.dat');
	imprimirListado(arc_emple,v);
end.
	
