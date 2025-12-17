import 'package:project_management/app/provider/theme_provider.dart';
import 'package:project_management/feature/invoices/presentation/view_model/invoice_vm.dart';
import 'package:project_management/feature/project/presentation/view_model/project_vm.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  // ChangeNotifierProvider<LocalizationProvider>(
  //   create: ((context) => LocalizationProvider(appData.read(kKeyLocale))),
  // ),
  ChangeNotifierProvider<ThemeProvider>(create: ((context) => ThemeProvider())),
  ChangeNotifierProvider<ProjectVm>(create: ((context) => ProjectVm())),
  ChangeNotifierProvider<InvoiceVm>(create: ((context) => InvoiceVm())),
];
