{5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años.

En pos de recuperar dicha información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro reuniendo dicha información.

Los archivos detalles con nacimientos, contendrán la siguiente información: 
nro partida nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico,
 nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre.
 
En cambio, los 50 archivos de fallecimientos tendrán: 
 nro partida nacimiento, DNI, nombre y apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y lugar.

Realizar un programa que cree el archivo maestro a partir de toda la información de los archivos detalles.
Se debe almacenar en el maestro: 
 nro partida nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico,
 nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
 además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. 
 
Se deberá, además, listar en un archivo de texto la información recolectada de cada persona.
 
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y además puede no haber fallecido.
* 
merge de 2 archivos diferentes

buscar minimo nacido
buscar minimo fallecido
mientras que los codigos de los 2 min sean diferentes a VALOR_ALTO
* 
* si  minN.nro<>VALOR_ALTO y minN.nro<minF.nro
* 	guardo min en maestro
* sino si min.nro<min


 
 

}

program ejercicio2_5;
const
	cantArc=50;
	VALOR_ALTO=9999;
type

	str=string[30];
	rNacimiento=record
		nro:integer;
		nombre:str;
		apellido:str;
		direccion:str;
		matriculaMed:integer;
		nomApeMadre:str;
		dniMadre:integer;
		nomApePadre:str;
		dniPadre:integer;
	end;
	rFallecimiento=record
		nro:integer;
		nombre:str;
		apellido:str;
		matriculaMedDeceso:integer;
		fechaYHora:str;
		lugar:str;
	end;
	rMaestro=record
		nro:integer;
		nombre:str;
		apellido:str;
		direccion:str; //nacimiento
		matriculaMed:integer; //nacimiento
		nomApeMadre:str; //nacimiento
		dniMadre:integer; //nacimiento
		nomApePadre:str; //nacimiento
		dniPadre:integer; //nacimiento
		matriculaMedDeceso:integer; //si fallecio
		fechaYhora:str; //si fallecio
		lugar:str; //si fallecio
	end;
	
	fNacimientos= file of rNacimiento;
	fFallecimientos = file of rFallecimiento;
	fMaestro= file of rMaestro;
	
	vF_Nacimientos= array[1..cantArc] of fNacimientos;
	vF_Fallecimientos= array[1..cantArc] of fFallecimientos;
	
	vR_Nacimientos= array[1..cantArc] of rNacimiento;
	vR_Fallecimientos= array[1..cantArc] of rFallecimiento;
	
procedure leerN(var arc_det: fNacimientos; var r:rNacimiento);
	begin
		if not eof(arc_det) then
			read(arc_det,r)
		else
			r.nro:=VALOR_ALTO;
	end;
	
procedure leerF(var arc_det: fFallecimientos; var r:rFallecimiento);
	begin
		if not eof(arc_det) then
			read(arc_det,r)
		else
			r.nro:=VALOR_ALTO;
	end;

procedure minimoN(var vFN:vF_Nacimientos; var vR:vR_Nacimientos; var min:rNacimiento);
	var
		minI,i:integer;
	begin
		minI:=-1;
		min.nro:=VALOR_ALTO;
		for i:=1 to cantArc do begin
			if vR[i].nro<>VALOR_ALTO then begin //si no esta vacio
				if (vR[i].nro < min.nro) then begin
					minI:=i;
					min.nro:=vR[i].nro;
				end
			end;
		end;
		if minI<>-1 then begin
			min:= vR[minI];
			leerN(vFN[minI],vR[minI]); //avanzo al siguente elemento de la sucursal leida y lo guardo en el vector de registros
		end;
	end;
procedure minimoF(var vFF:vF_Fallecimientos; var vR:vR_Fallecimientos; var min:rFallecimiento); //nunca va a devolver valor alto ?)
	var
		minI,i:integer;
	begin
		minI:=-1;
		min.nro:=VALOR_ALTO;
		for i:=1 to cantArc do begin
			if vR[i].nro<>VALOR_ALTO then begin //si no esta vacio
				if (vR[i].nro < min.nro) then begin
					minI:=i;
					min.nro:=vR[i].nro;
				end
			end;
		end;
		if minI<>-1 then begin
			min:= vR[minI];
			leerF(vFF[minI],vR[minI]); //avanzo al siguente elemento de la sucursal leida y lo guardo en el vector de registros
		end;
	end;
	//asumiento que cada fallecido va a tener un acta de nacimiento
procedure crearMaestro(var arcMaestro:fMaestro);
	var
		vFN:vF_Nacimientos;
		vRN:vR_Nacimientos;
		minN:rNacimiento;
		vFF:vF_Fallecimientos;
		vRF:vR_Fallecimientos;
		minF:rFallecimiento;
		i:integer;
		rMae:rMaestro;
	begin
		//assign de los 50 archivos de fallecimientos
		//assign de los 50 archivos de nacimientos
		//reset de los 50 archivos de fallecimientos
		//reset de los 50 archivos de nacimientos
		//guardado del primer elemento de cada archivo en verctor de registro de nacidos
		//guardado del primer elemento de cada archivo en verctor de registro de fallecidos
		rewrite(arcMaestro);
		minimoN(vFN,vRN,minN);
		while minN.nro<>VALOR_ALTO do begin
			minimoF(vFF,vRF,minF); //busco el nro min de fallecido
			while minN.nro<minF.nro do begin // mientras no llegue una partida de alguien fallecido
				rMae.nro:=minN.nro;
				rMae.nombre:=minN.nombre;
				rMae.apellido:=minN.apellido;
				rMae.direccion:=minN.direccion;
				rMae.matriculaMed:=minN.matriculaMed;
				rMae.nomApeMadre:=minN.nomApeMadre;
				rMae.dniMadre:=minN.dniMadre;
				rMae.nomApePadre:=minN.nomApePadre;
				rMae.dniPadre:=minN.dniPadre;
				rMae.matriculaMedDeceso:=-1; //-1 porque no existe
				rMae.fechaYhora:='no fallecio';
				rMae.lugar:='no fallecio';
				write(arcMaestro,rMae);
				minimoN(vFN,vRN,minN);
			end;
			//sale del while cuando encuentre partida de un fallecido, combina los datos
			rMae.nro:=minN.nro;
			rMae.nombre:=minN.nombre;
			rMae.apellido:=minN.apellido;
			rMae.direccion:=minN.direccion;
			rMae.matriculaMed:=minN.matriculaMed;
			rMae.nomApeMadre:=minN.nomApeMadre;
			rMae.dniMadre:=minN.dniMadre;
			rMae.nomApePadre:=minN.nomApePadre;
			rMae.dniPadre:=minN.dniPadre;
			rMae.matriculaMedDeceso:=minF.matriculaMedDeceso;
			rMae.fechaYhora:=minF.fechaYhora;
			rMae.lugar:=minF.lugar;
			write(arcMaestro,rMae);
			minimoN(vFN,vRN,minN);
		end;
		//close de TODOS LOS ARCHIVOS!!
	end;
	
	
begin
	//asign maestro

end.

