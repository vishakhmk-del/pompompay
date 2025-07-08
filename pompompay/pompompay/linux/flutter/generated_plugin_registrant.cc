//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <open_file_linux/open_file_linux_plugin.h>
#include <sim_number_picker/sim_number_picker_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) open_file_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpenFileLinuxPlugin");
  open_file_linux_plugin_register_with_registrar(open_file_linux_registrar);
  g_autoptr(FlPluginRegistrar) sim_number_picker_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SimNumberPickerPlugin");
  sim_number_picker_plugin_register_with_registrar(sim_number_picker_registrar);
}
