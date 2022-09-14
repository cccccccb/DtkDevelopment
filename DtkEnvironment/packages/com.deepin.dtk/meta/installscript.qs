function Component()
{
    if (!installer.isCommandLineInstance())
        gui.pageWidgetByObjectName("LicenseAgreementPage").entered.connect(changeLicenseLabels);
    component.addOperation("Execute", "@TargetDir@/ReplaceUserPath.sh", "@TargetDir@")
}

changeLicenseLabels = function()
{
    page = gui.pageWidgetByObjectName("LicenseAgreementPage");
    page.AcceptLicenseLabel.setText("Yes I do!");
}
