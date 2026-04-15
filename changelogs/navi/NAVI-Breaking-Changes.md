# Navi Breaking-Changes

## [2.53.0]

Object name generation has changed: the chart previously used navi-async-matrix.fullname, but now uses generic-chart.fullname. This may change the names of rendered navi-async-matrix objects. To preserve the previous naming, explicitly set fullnameOverride in values to the old full name.
