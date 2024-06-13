--Enviando correos SQL 
--1... Creando perfil
Execute msdb.dbo.sysmail_add_profile_sp
	@profile_name = 'Notificaciones',
	@Description = 'Perfil para mandar correos ABD'

--Dar acceso a los usuarios al perfil del correo
Execute msdb.dbo.sysmail_add_principalprofile_sp
	@profile_name = 'Notificaciones',
	@principal_name = 'public',
	@is_default = 1

--creando una cuenta de correo en la base de datos
execute msdb.dbo.sysmail_add_account_sp
	@account_name = 'Luisa04IL',
	@Description = 'Enviar correos',
	@email_address = 'luisacrossway@gmail.com',
	@display_name = 'Enviando correos',
	@mailserver_name = 'smtp.gmail.com',
	@port = 587,
	@enable_ssl = 1,
	@UserName = 'luisacrossway@gmail.com',
	@password = 'ikkj bcof ipmg aplv'

--Agregar la cuenta al perfil de notificaciones
Execute msdb.dbo.sysmail_add_profileaccount_sp
 @profile_name = 'Notificaciones',
 @account_name = 'Luisa04IL',
 @sequence_number = 1
--Confirmar que todo este bien
 select *
 from msdb.dbo.sysmail_profile p
 join msdb.dbo.sysmail_profileaccount pa on p.profile_id = pa.profile_id
 join msdb.dbo.sysmail_account a on pa.account_id = a.account_id
 join msdb.dbo.sysmail_server s on a.account_id = s.account_id

 --	Se ejecutan estos 2 ultimos :D.. juntossssssss
 Declare @BODY varchar(max);
 set @BODY = '<!DOCTYPE html>
				<html lang = "en">
				<head>
				<meta charset = "UTF-8"
				 <META NAME = "viewport" content = "width = device-width", initial-sacled=1.0">
				 </head?
				 <body>
				 <center> <img src = "https://www.pnguniverse.com/wp-content/uploads/2020/11/UNI-Nicaragua-980x603.png" alt = "" width = "200"></center>
			<h3> Correo de Luisa Téllez :D </h3?
				</body>
				</html>';

			Execute msdb.dbo.sp_send_dbmail
				@profile_name = 'Notificaciones',
				@recipients = 'luisacrossway@gmail.com',
				--@copy_recipients = 'luistellez0510@gmail.com' ,
				@body = @BODY, 
				@body_Format = 'HTML',
				@subject = 'Correo de prueba :D'

--- Plan de mantenimiento SQL