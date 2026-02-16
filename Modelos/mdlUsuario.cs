using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlUsuario
    {
        #region Atributos

        private int usuario_id;
        private string identificacion;
        private int tipo_identificacion_id;
        private string nombre_completo;
        private string telefono;
        private string correo;
        private string contrasena;
        private string rol;
        private string estado;
        private DateTime fecha_creacion;
        private string creado_por;
        private DateTime? fecha_modificacion;
        private string modificado_por;

        #endregion

        #region Constructores

        // Constructor vacío
        public mdlUsuario()
        {
            this.usuario_id = 0;
            this.identificacion = "";
            this.tipo_identificacion_id = 0;
            this.nombre_completo = "";
            this.telefono = "";
            this.correo = "";
            this.contrasena = "";
            this.rol = "";
            this.estado = "";
            this.creado_por = "";
            this.modificado_por = "";

            this.fecha_creacion = DateTime.Now;
            this.fecha_modificacion = null;
        }

        // Constructor para insertar
        public mdlUsuario(
            string identificacion,
            int tipo_identificacion,
            string nombre_completo,
            string telefono,
            string correo,
            string contrasena,
            string rol,
            string estado,
            string creado_por)
        {

            this.identificacion = identificacion;
            this.tipo_identificacion_id = tipo_identificacion;
            this.nombre_completo = nombre_completo;
            this.telefono = telefono;
            this.correo = correo;
            this.contrasena = contrasena;
            this.rol = rol;
            this.estado = estado;
            this.creado_por = creado_por;

            this.fecha_creacion = DateTime.Now;
        }

        // Constructor para editar
        public mdlUsuario(
            int usuario_id,
            string identificacion,
            int tipo_identificacion,
            string nombre_completo,
            string telefono,
            string correo,
            string contrasena,
            string rol,
            string estado,
            DateTime fecha_modificacion,
            string modificado_por)
        {
            this.usuario_id = usuario_id;
            this.tipo_identificacion_id = tipo_identificacion;
            this.identificacion = identificacion;
            this.nombre_completo = nombre_completo;
            this.telefono = telefono;
            this.correo = correo;
            this.contrasena = contrasena;
            this.rol = rol;
            this.estado = estado;
            this.fecha_modificacion = fecha_modificacion;
            this.modificado_por = modificado_por;
        }

        // Constructor para login
        public mdlUsuario(string correo, string contrasena)
        {
            this.correo = correo;
            this.contrasena = contrasena;
        }

        #endregion

        #region Propiedades Públicas

        public int UsuarioId
        {
            get { return usuario_id; }
            set { usuario_id = value; }
        }

        public string Identificacion
        {
            get { return identificacion; }
            set { identificacion = value; }
        }

        public int TipoIdentificacionId
        {
            get { return tipo_identificacion_id; }
            set { tipo_identificacion_id = value; }
        }

        public string NombreCompleto
        {
            get { return nombre_completo; }
            set { nombre_completo = value.ToUpper(); }
        }

        public string Telefono
        {
            get { return telefono; }
            set { telefono = value; }
        }

        public string Correo
        {
            get { return correo; }
            set { correo = value; }
        }

        public string Contrasena
        {
            get { return contrasena; }
            set { contrasena = value; }
        }
        public string Mensaje { get; set; }


        public string Rol
        {
            get { return rol; }
            set { rol = value; }
        }

        public string Estado
        {
            get { return estado; }
            set { estado = value; }
        }

        public DateTime FechaCreacion
        {
            get { return fecha_creacion; }
            set { fecha_creacion = value; }
        }

        public DateTime? FechaModificacion
        {
            get { return fecha_modificacion; }
            set { fecha_modificacion = value; }
        }

        public string CreadoPor
        {
            get { return creado_por; }
            set { creado_por = value; }
        }

        public string ModificadoPor
        {
            get { return modificado_por; }
            set { modificado_por = value; }
        }

        #endregion
    }
}