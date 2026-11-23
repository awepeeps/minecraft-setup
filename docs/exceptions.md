# Exceptions

| Rule | Reason | Revisit |
| --- | --- | --- |
| C7.4 | The portable mock suites and the YAML validator run in Python and shell because they exercise server automation (shell) and parse YAML templates; TypeScript has no dependency-free YAML parser here. | 2027-02-23 |
