Add-PrinterDriver -Name "<yourPrinterDriverName>"
Add-PrinterPort -Name '<yourPortName>' -PrinterHostAddress 'ipp://<yourIPPServerDomain>:<yourIppServerPortNumber>/ipp/print'
Add-Printer -DriverName "<yourPrinterDriverName>" -Name "<yourPrinterName>" -PortName "<yourPrinterPortName>"