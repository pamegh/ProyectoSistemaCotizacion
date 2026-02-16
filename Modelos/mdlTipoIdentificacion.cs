using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProyectoSistemaCotizacion.Modelos
{
    public class mdlTipoIdentificacion
    {
            #region Atributos

            private int tipoIdentificacionId;
            private string codigo;
            private string nombre;
            private string descripcion;
            private int longitudMin;
            private int longitudMax;
            private string patronRegex;
            private bool soloNumerico;
            private bool estado;
            private DateTime fechaCreacion;
            private DateTime? fechaModificacion;
            private string creadoPor;
            private string modificadoPor;

            #endregion

            #region Propiedades

            public int TipoIdentificacionId
            {
                get { return tipoIdentificacionId; }
                set { tipoIdentificacionId = value; }
            }

            public string Codigo
            {
                get { return codigo; }
                set { codigo = value?.Trim().ToUpper(); }
            }

            public string Nombre
            {
                get { return nombre; }
                set { nombre = value?.Trim().ToUpper(); }
            }

            public string Descripcion
            {
                get { return descripcion; }
                set { descripcion = value?.Trim(); }
            }

            public int LongitudMin
            {
                get { return longitudMin; }
                set { longitudMin = value; }
            }

            public int LongitudMax
            {
                get { return longitudMax; }
                set { longitudMax = value; }
            }

            public string PatronRegex
            {
                get { return patronRegex; }
                set { patronRegex = value; }
            }

            public bool SoloNumerico
            {
                get { return soloNumerico; }
                set { soloNumerico = value; }
            }

            public bool Estado
            {
                get { return estado; }
                set { estado = value; }
            }

            public DateTime FechaCreacion
            {
                get { return fechaCreacion; }
                set { fechaCreacion = value; }
            }

            public DateTime? FechaModificacion
            {
                get { return fechaModificacion; }
                set { fechaModificacion = value; }
            }

            public string CreadoPor
            {
                get { return creadoPor; }
                set { creadoPor = value; }
            }

            public string ModificadoPor
            {
                get { return modificadoPor; }
                set { modificadoPor = value; }
            }

            #endregion
        }
    }
