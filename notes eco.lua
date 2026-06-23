require "import"
import "android.widget.*"
import "android.content.*"
import "android.view.*"
import "com.androlua.*"
import "java.io.File"

local carpetaNotas = "/storage/emulated/0/53/"
os.execute("mkdir -p " .. carpetaNotas)

local layoutPrincipal = {
  LinearLayout,
  orientation = "vertical",
  layout_width = "match_parent",
  layout_height = "match_parent",
  {
    Button,
    text = "Nueva nota",
    onClick = function()
      mostrarDialogoNuevaNota()
    end,
    layout_width = "match_parent",
    layout_height = "wrap_content",
    layout_margin = "8dp",
  },
  {
    Button,
    text = "Salir",
    onClick = function()
      dlg.dismiss()
      -- Si deseas cerrar el servicio completamente, descomenta la siguiente línea:
      -- service.stopSelf()
    end,
    layout_width = "match_parent",
    layout_height = "wrap_content",
    layout_margin = "8dp",
  },
}

function mostrarDialogoNuevaNota()
  local layoutNota = {
    LinearLayout,
    orientation = "vertical",
    layout_width = "match_parent",
    layout_height = "match_parent",
    {
      TextView,
      text = "Título del archivo:",
      textSize = "14sp",
      layout_width = "match_parent",
      layout_height = "wrap_content",
    },
    {
      EditText,
      hint = "Escribe el título",
      id = "tituloNota",
      layout_width = "match_parent",
      layout_height = "wrap_content",
    },
    {
      TextView,
      text = "Contenido del archivo:",
      textSize = "14sp",
      layout_width = "match_parent",
      layout_height = "wrap_content",
    },
    {
      EditText,
      hint = "Escribe el contenido",
      id = "contenidoNota",
      layout_width = "match_parent",
      layout_height = "wrap_content",
      lines = 6,
    },
    {
      Button,
      text = "Aceptar",
      onClick = function()
        guardarNota(tituloNota.Text, contenidoNota.Text)
      end,
      layout_width = "match_parent",
      layout_height = "wrap_content",
      layout_margin = "8dp",
    },
    {
      Button,
      text = "Cancelar",
      onClick = function()
        dlgNota.dismiss()
      end,
      layout_width = "match_parent",
      layout_height = "wrap_content",
      layout_margin = "8dp",
    },
  }

  dlgNota = LuaDialog(service)
  dlgNota.View = loadlayout(layoutNota)
  dlgNota.show()
end

function guardarNota(titulo, contenido)
  if titulo ~= "" and contenido ~= "" then
    local rutaArchivo = carpetaNotas .. titulo .. ".txt"
    local archivo = io.open(rutaArchivo, "w")
    if archivo then
      archivo:write(contenido)
      archivo:close()
      service.asyncSpeak("Nota guardada exitosamente.")
      dlgNota.dismiss()
    else
      service.asyncSpeak("Error al guardar la nota.")
    end
  else
    service.asyncSpeak("Por favor, ingresa un título y contenido.")
  end
end

dlg = LuaDialog(service)
dlg.View = loadlayout(layoutPrincipal)
dlg.show() -- bloc de notas de pedrito
