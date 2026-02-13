using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace ProyectoSistemaCotizacion.Utilidades
{
    public class util
    {
        public static void validarSoloLetras(TextCompositionEventArgs e)
        {
            int ascci = Convert.ToInt32(Convert.ToChar(e.Text));
            if (ascci >= 65 && ascci <= 90 || ascci >= 97 && ascci <= 122)
            {
                e.Handled = false;
            }
            else
            {
                MessageBox.Show("Solo se permiten letras!", "Advertencia", MessageBoxButton.OK);
                e.Handled = true;
            }
        }
        public static void limpiarCampos(List<TextBox> campos)
        {
            for (int x = 0; x < campos.Count; x++)
            {
                campos[x].Text = "";
            }
        }
    }
}
