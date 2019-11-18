===============================================================================================================
						README BdsDemo
===============================================================================================================

1. Data modules

To demonstrate how it works with the various database access technologies, the project includes several 
data modules (see form / UDm ...) with the corresponding components. Use for a test each only one of the 
data modules 

2. CommonConnector

Each existing data module contains a TSFConnector component, each of which is as CommonConnector defined. 
The CommonConnector property indicates that this connector is automatically used by all created
DataSets (TSFBusinessData). For this reason, a project can only contain one CommonConnector.
Further information can be found in the documentation.

3. Delphi datbase components

Depending on the Delphi version used, some components included in the data modules, such as
z. FireDac, are not available.
If necessary, remove the relevant data module from the project.

4. Database files

The files for creating the test databases can be found in the subdirectory db.
