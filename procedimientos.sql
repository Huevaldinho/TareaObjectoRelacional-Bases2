

--Felipe
    --CRUD Clientes

--Create Cliente
CREATE FUNCTION Create_Cliente (numeroCedula integer,
        nombre varchar(20), apellidos varchar(20) array[3],
        fechaNacimiento date, correos varchar(100) array[2],
        telefonos varchar(10) array[2]) returns cliente AS $funcion_CreateCliente$
	DECLARE clienteIngresado cliente;
    BEGIN
      --Validar nulos
	    if (numeroCedula is null or nombre is null or apellidos is null or 
            fechaNacimiento is null or correos is null or telefonos is null) then
			
                raise notice 'Error, debe ingresar los parametros 
                 numeroCedula, nombre,apellidos,fechaNacimiento,correos y telefonos
                 para crear a un cliente.';
        elsif fechaNacimiento>NOW() then
            raise notice 'Error, la fecha de nacimiento ingresada no es valida.';
        else 
            INSERT INTO Cliente(datosPersonales)  
				SELECT (numeroCedula,nombre,apellidos,fechaNacimiento,correos,telefonos)::persona
				WHERE NOT EXISTS(SELECT 1 FROM Cliente WHERE (datosPersonales).numeroCedula = numeroCedula);

        end if;
	select * from Cliente where (datosPersonales).numeroCedula=numeroCedula into clienteIngresado;
	return clienteIngresado;
    END; $funcion_CreateCliente$ LANGUAGE plpgsql;
	
select Create_Cliente(1564,'Felipe',array['Obando','Arrieta'],
				 TO_DATE('31/10/2001','DA/MM/YYYY'), array['felipeobando@gmail.com'],array['70130686']);--Sirve
SELECT Create_Cliente(1564,'Felipe',array['Obando','Arrieta'],
				 TO_DATE('31/10/2001','DA/MM/YYYY'), array['felipeobando@gmail.com'],array['70130686']);--Sirve, no repite clientes.
SELECT Create_Cliente(87431,'Sebastian',array['Bermudez','Chacon'],
				 TO_DATE('01/04/2003','DA/MM/YYYY'), array['sebastianbermudez@gmail.com','sebasgay@hotmail.com'],
				 array['8115153','60487716']);--Sirve
select * from Cliente;



--Read Cliente
CREATE FUNCTION Read_Cliente (idCliente_ int, cedula int) 
RETURNS cliente AS $funcion_Read_Cliente$
   DECLARE
      clienteSeleccionado Cliente;
   BEGIN
   
      SELECT Cliente.idCliente,Cliente.datosPersonales from Cliente where (	
					(datosPersonales).numeroCedula = cedula or Cliente.idCliente = idCliente_
				) into clienteSeleccionado  ;
	  
	  
      RETURN clienteSeleccionado;
   END; $funcion_Read_Cliente$ LANGUAGE plpgsql;

select Read_Cliente(2,1);--Sirve
select Read_Cliente(20,1);--Sirve
select * from Cliente;



--Update Cliente
CREATE FUNCTION Update_Cliente (idCliente_ int, numeroCedula integer,
                            nombre varchar(20), apellidos varchar(20) array[3],
                            fechaNacimiento date, correos varchar(100) array[2],
                            telefonos varchar(10) array[2]) 
RETURNS cliente AS $funcion_Update_Cliente$
   DECLARE
      clienteModificado Cliente;
   BEGIN
        --Validar nulos
        if (numeroCedula is null and idCliente_ is null) then
            raise notice 'Error, debe ingresar idCliente o numeroCedula para consultar datos de cliente.';
        else                                            --si el primer argumento es null retorna el segundo
            UPDATE Cliente set datosPersonales.nombre = COALESCE(nombre  ,datosPersonales.nombre),
                    datosPersonales.apellidos = COALESCE(apellidos  ,datosPersonales.apellidos),
                    datosPersonales.fechaNacimiento = COALESCE(fechaNacimiento  ,datosPersonales.fechaNacimiento),
                    datosPersonales.correos = COALESCE(correos  ,datosPersonales.correos),
                    datosPersonales.telefonos = COALESCE(telefonos  ,datosPersonales.telefonos)
                from Cliente where Cliente.idCliente = idCliente_ or (datosPersonales).numeroCedula = numeroCedula;
        end if;
        
    select * from Cliente where (datosPersonales).numeroCedula=numeroCedula into clienteIngresado;
    RETURN clienteModificado;
   END; $funcion_Update_Cliente$ LANGUAGE plpgsql;

--Update Cliente
CREATE FUNCTION Update_Cliente (idCliente_ int, numeroCedula integer,
                            nombre varchar(20), apellidos varchar(20) array[3],
                            fechaNacimiento date, correos varchar(100) array[2],
                            telefonos varchar(10) array[2]) 
RETURNS cliente AS $funcion_Update_Cliente$
   DECLARE
      clienteModificado Cliente;
   BEGIN
        --Validar nulos
        if (numeroCedula is null and idCliente_ is null) then
            raise notice 'Error, debe ingresar idCliente o numeroCedula para modificar datos de cliente.';
			return null;
        else                                            --si el primer argumento es null retorna el segundo
            UPDATE Cliente set datosPersonales.nombre = COALESCE(nombre  ,(datosPersonales).nombre),
                    datosPersonales.apellidos = COALESCE(apellidos  ,(datosPersonales).apellidos),
                    datosPersonales.fechaNacimiento = COALESCE(fechaNacimiento  ,(datosPersonales).fechaNacimiento),
                    datosPersonales.correos = COALESCE(correos  ,(datosPersonales).correos),
                    datosPersonales.telefonos = COALESCE(telefonos  ,(datosPersonales).telefonos)
               where Cliente.idCliente = idCliente_ or (datosPersonales).numeroCedula = numeroCedula;
			 --Si el cliente existe lo modificar pero si no existe no hace nada porque no encuentra nada en el where.
			select * from Cliente where (datosPersonales).numeroCedula=numeroCedula or Cliente.idCliente=idCliente_ into clienteModificado;
        end if;
   RETURN clienteModificado;
   END; $funcion_Update_Cliente$ LANGUAGE plpgsql;

select * from Cliente;
select * from Update_Cliente(null,null,null,null,null, null,null);--Sirve, no trae nada, en messages esta el mensaje.
select * from Update_Cliente(null,null,'Mauricio',null,null, null,null);--Sirve, no trae nada, en messages esta el mensaje.
select * from Update_Cliente(null,1,'Mauricio',null,null, null,null);--Sirve, no modifica nada porque no hay persona con cedula =1.
select * from Update_Cliente(1,null,'Mauricio',null,null, null,null);--Sirve, modificar nombre con el idCliente ingresado.
select * from Update_Cliente(null,87431,'Carlos',null,null, null,null);--Sirve, modificar nombre con el numeroCedula ingresado.

--Delete Cliente
CREATE FUNCTION Delete_Cliente (idCliente_ int, numeroCedula integer) 
RETURNS cliente AS $funcion_Delete_Cliente$
   DECLARE
      clienteEliminado Cliente;
   BEGIN
        --Validar nulos
        if (numeroCedula is null and idCliente_ is null) then
            raise notice 'Error, debe ingresar idCliente o numeroCedula para eliminar a un cliente.';
			return null;
        else                                            --si el primer argumento es null retorna el segundo
			select * from Cliente where (datosPersonales).numeroCedula=numeroCedula or Cliente.idCliente=idCliente_ into clienteEliminado;
            DELETE from Cliente where Cliente.idCliente=idCliente_ or (datosPersonales).numeroCedula=numeroCedula;

        end if;
   RETURN clienteEliminado;
   END; $funcion_Delete_Cliente$ LANGUAGE plpgsql;
   
select * from Cliente;
select * from Delete_Cliente(null,null);--Sirve, no hace nada solo muestra mensaje
select * from Delete_Cliente(1,null);--Sirve, seleciona el cliente que borra antes de borrarlo para mostarlo.
--Sebastian
    --CRUD Productos y clientes

--CREATE PRODUCTO
CREATE OR REPLACE FUNCTION public.createproducto(
	in_cantidad integer,
	in_precio integer,
	in_nombre character varying,
	in_autores autor[],
	in_descripcion character varying[],
	in_categorias character varying[])
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$ 
	DECLARE productoIngresado character varying;
	BEGIN
	
	if (in_cantidad is null OR
		in_precio is null OR
		in_nombre is null OR
		in_autores is null OR
		in_descripcion is null OR
		in_categorias is null
	   ) then
		RAISE NOTICE 'Error, debe ingresar correctamente todos los datos.';
	else
		RAISE NOTICE 'ENTRO al else XDXDX';
		INSERT INTO public.productos(producto)
			SELECT(in_cantidad, in_precio, in_nombre, in_autores, in_descripcion, in_categorias)::producto
			WHERE NOT EXISTS(SELECT 1 FROM productos where (producto).nombre = in_nombre); 
			--se valida con el nombre del producto, es un poco ineficiente pero tampoco es problema, no se van a repetir.

	end if;
	
	select (producto).nombre from Productos where (producto).nombre = in_nombre into productoIngresado;
	RAISE NOTICE 'LO SELECCIONA EN PRODUCTOINGRESADO';
	return productoIngresado;
	END; 
$BODY$;

SELECT public.createproducto( --prueba sirve
	5, 
	1000, 
	'El triangulo', 
	array[('ganoza b', 'bejugod')::autor], 
	array['muy pichudo'], 
	array['rock','pop','clasica']
);

--READ PRODUCTO
CREATE OR REPLACE FUNCTION public.readproducto( --:)
	in_idproducto integer)
    RETURNS Productos
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	DECLARE
		productoSeleccionado Productos;
	BEGIN
		SELECT Productos.idProducto, Productos.producto from Productos
		where Productos.idProducto = in_idProducto into productoSeleccionado;
		
		RETURN productoSeleccionado;
	END; 
$BODY$;

--UPDATE PRODUCT
CREATE FUNCTION updateProducto(
	in_idProducto integer,
	in_cantidad integer,
	in_precio integer,
	in_nombre character varying,
	in_autores autor[],
	in_descripcion character varying[],
	in_categorias character varying[])
	RETURNS Productos AS $function_updateProducto$
		DECLARE
			productoActualizado Productos;
		BEGIN
			if (in_idProducto is null) then
				RAISE NOTICE 'Error, no ingresó id del producto';
				return null;
			else
				UPDATE Productos set
					producto.cantidad = COALESCE(in_cantidad,(producto).cantidad),
					producto.precio = COALESCE(in_precio,(producto).precio),
					producto.nombre = COALESCE(in_nombre,(producto).nombre),
					producto.autores = COALESCE(in_autores,(producto).autores),
					producto.descripcion = COALESCE(in_descripcion,(producto).descripcion),
					producto.categorias = COALESCE(in_categorias,(producto).categorias)
				where Productos.idProducto = in_idProducto;
				
				SELECT Productos.idProducto, Productos.producto from Productos
				where Productos.idProducto = in_idProducto into productoActualizado;
			END IF;
			RETURN productoActualizado;
		END; $function_updateProducto$ LANGUAGE plpgsql;

--si sirve, borré la prueba sin querer xd

--DELETE PRODUCT
CREATE OR REPLACE FUNCTION deleteProduct (in_idProduct int) 
RETURNS Productos AS $function_deleteProduct$
   DECLARE
      productoEliminado Productos;
   BEGIN
        --Validar nulos
        if (in_idProduct is null) then
            raise notice 'Error, debe ingresar el id del producto para eliminarlo.';
			return null;
        else                                            --si el primer argumento es null retorna el segundo
			SELECT Productos.idProducto, Productos.producto from Productos
			where Productos.idProducto = in_idProduct into productoEliminado;
            
			DELETE from Productos where Productos.idProducto=in_idProduct;

        end if;
   RETURN productoEliminado;
   END;$function_deleteProduct$ LANGUAGE plpgsql;

select public.deleteproduct(10);


--Juntos
    --Facturacion
    --Productos Vendidos