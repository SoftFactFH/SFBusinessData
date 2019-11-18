===============================================================================================================
						README BdsDemo
===============================================================================================================

1. Datenmodule

Zur Demonstration der Funktionsweise mit den verschiedenen Datenbankzugriffstechnologien, enth�lt das Projekt
mehrere Datenmodule (s. form/UDm...) mit den entsprechenden Komponenten. Verwenden Sie f�r einen Test jeweils
nur eines der Datenmodule 

2. CommonConnector

Jedes vorhandene Datenmodul enth�lt eine Komponente vom Typ TSFConnector, welcher jeweils als CommonConnector
definiert ist. Die Eigenschaft CommonConnector gibt an, dass dieser Connector automatisch von allen erzeugten
DataSets (TSFBusinessData) verwendet wird. Aus diesem Grund kann ein Projekt nur einen CommonConnector beinhalten.
Weitere Informationen hierzu entnehmen Sie bitte der Dokumentation.

3. Delphi-Datenbankkomponenten

Abh�ngig von der verwendeten Delphi-Version sind evtl. manche Komponenten in den beinhalteten Datenmodulen, wie 
z. B. FireDac, nicht verf�gbar.
Falls erforderlich entfernen Sie das betreffende Datenmodul aus dem Projekt.

4. Datenbankfiles

Die Dateien zur Erzeugung der Testdatenbanken finden Sie im Unterverzeichnis db.
