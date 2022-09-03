
/* Plantilla sp
create [or replace] procedure procedure_name(parameter_list)
    language plpgsql
    as $$
    declare
    -- variable declaration
    begin
    -- stored procedure body
    end; $$

*/


--Felipe
    --CRUD Clientes
CREATE PROCEDURE sp_Clientes(opcion int,idCliente int, numeroCedula integer,
                            nombre varchar(20), apellidos varchar(20) array[3],
                            fechaNacimiento date, correos varchar(100) array[2],
                            telefonos varchar(10) array[2])
    language plpgsql AS $$

    
    BEGIN
        --Opciones: 1 Create, 2 Read, 3 Update y 4 Delete
         
		if opcion=1 then --Create - LISTO
            --Validar nulos
            if (numeroCedula is null or nombre is null or apellidos is null or 
            fechaNacimiento is null or correos is null or telefonos is null) then
			
                raise notice 'Error, debe ingresar los parametros 
                 numeroCedula, nombre,apellidos,fechaNacimiento,correos y telefonos
                 para crear a un cliente.';
				 
            else--Si ingresaron parametros
               
               INSERT INTO Cliente(datosPersonales)  
				SELECT (numeroCedula,nombre,apellidos,fechaNacimiento,correos,telefonos)::persona
				WHERE NOT EXISTS(SELECT 1 FROM Cliente WHERE (datosPersonales).numeroCedula = numeroCedula);
                --se podria hacer algo para que se identifique el caso cuando si inserta y cuando no lo hace porque
                --tiene la cedula repetida.
                            
            end if;
		elsif  opcion=2 then

        elsif  opcion=3 then

        elsif  opcion=4 then

        else 
            raise notice 'Error, ha ingresado una opcion invalida.';
		END if;

END; $$

call sp_Clientes(1,null,null,null,null,null,null,null);
call sp_Clientes(2,null,null,null,null,null,null,null);
call sp_Clientes(3,null,null,null,null,null,null,null);
call sp_Clientes(4,null,null,null,null,null,null,null);
call sp_Clientes(10,null,null,null,null,null,null,null);

call sp_Clientes(1,null,1564,'Felipe',array['Obando','Arrieta'],
				 TO_DATE('31/10/2001','DA/MM/YYYY'), array['felipeobando@gmail.com'],array['70130686']);--Sirve
call sp_Clientes(1,null,1564,'Felipe',array['Obando','Arrieta'],
				 TO_DATE('31/10/2001','DA/MM/YYYY'), array['felipeobando@gmail.com'],array['70130686']);--Sirve, no hace nada
				 --o sea el exist not si funciona y no deja repetir numeros de cedula.
call sp_Clientes(1,null,87431,'Sebastian',array['Bermudez','Chacon'],
				 TO_DATE('01/04/2003','DA/MM/YYYY'), array['sebastianbermudez@gmail.com','sebasgay@hotmail.com'],
				 array['8115153','60487716']);--Sirve

--Sebastian
    --CRUD Productos y clientes
--Juntos
    --Facturacion
    --Productos Vendidos