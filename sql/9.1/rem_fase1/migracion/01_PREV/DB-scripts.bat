echo 'exit' | sqlplus HAYA01/%2 @./scripts/DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.log
if errorlevel 1 (
  echo ERROR. Revise DDL_0068_REM_HAYA01_DD_COD_NOT_EXISTS.log
  exit 1
)
echo 'exit' | sqlplus HAYA01/%2 @./scripts/DDL_0069_REM_HAYA01_ACT_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.log
if errorlevel 1 (
  echo ERROR. Revise DDL_0069_REM_HAYA01_ACT_NOT_EXISTS.log
  exit 1
)
echo 'exit' | sqlplus HAYA01/%2 @./scripts/DDL_0070_REM_HAYA01_CPR_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.log
if errorlevel 1 (
  echo ERROR. Revise DDL_0070_REM_HAYA01_CPR_NOT_EXISTS.log
  exit 1
)
echo 'exit' | sqlplus HAYA01/%2 @./scripts/DDL_0071_REM_HAYA01_PRO_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.log
if errorlevel 1 (
  echo ERROR. Revise DDL_0071_REM_HAYA01_PRO_NOT_EXISTS.log
  exit 1
)
echo 'exit' | sqlplus HAYA01/%2 @./scripts/DDL_0072_REM_HAYA01_AGR_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.log
if errorlevel 1 (
  echo ERROR. Revise DDL_0072_REM_HAYA01_AGR_NOT_EXISTS.log
  exit 1
)
echo 'exit' | sqlplus HAYA01/%2 @./scripts/DDL_0073_REM_HAYA01_PVE_NOT_EXISTS-HAYA01-reg3.1.sql > DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.log
if errorlevel 1 (
  echo ERROR. Revise DDL_0073_REM_HAYA01_PVE_NOT_EXISTS.log
  exit 1
)
echo 'exit' | sqlplus HAYA01/%2 @./scripts/DML_0070_REM_HAYA01_INSERT_DD_ENO_9999-HAYA01-reg3.1.sql > DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.log
if errorlevel 1 (
  echo ERROR. Revise DML_0070_REM_HAYA01_INSERT_DD_ENO_9999.log
  exit 1
)
