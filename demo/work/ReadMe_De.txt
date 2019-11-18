===============================================================================================================
						README BdsDemo
===============================================================================================================

1. Datenmodule

Zur Demonstration der Funktionsweise mit den verschiedenen Datenbankzugriffstechnologien, enthält das Projekt
mehrere Datenmodule (s. form/UDm...) mit den entsprechenden Komponenten. Verwenden Sie für einen Test jeweils
nur eines der Datenmodule 

2. CommonConnector

Jedes vorhandene Datenmodul enthält eine Komponente vom Typ TSFConnector, welcher jeweils als CommonConnector
definiert ist. Die Eigenschaft CommonConnector gibt an, dass dieser Connector automatisch von allen erzeugten
DataSets (TSFBusinessData) verwendet wird. Aus diesem Grund kann ein Projekt nur einen CommonConnector beinhalten.
Weitere Informationen hierzu entnehmen Sie bitte der Dokumentation.

3. Delphi-Datenbankkomponenten

Abhängig von der verwendeten Delphi-Version sind evtl. manche Komponenten in den beinhalteten Datenmodulen, wie 
z. B. FireDac, nicht verfügbar.
Falls erforderlich entfernen Sie das betreffende Datenmodul aus dem Projekt.

4. Datenbankfiles

Die Dateien zur Erzeugung der Testdatenbanken finden Sie im Unterverzeichnis db.
