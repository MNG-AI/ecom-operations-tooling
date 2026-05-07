' ============================================================
' Module:   CopyAllSamplesByBgrp
' Author:   Stanley Carter
' Purpose:  Routes sample data from the "Exceptions Report" tab
'           to the correct department tab based on BGRP code.
'           Eliminates manual sorting and reduces misrouting errors
'           in the eCommerce sample-to-site workflow.
' ============================================================
' HOW IT WORKS:
'   1. Reads each row from the "Exceptions Report" sheet
'   2. Looks up the BGRP code in Column E
'   3. Maps that code to the correct department tab
'   4. Copies the full row (columns A:T) to the next available
'      row in the matching department tab
'
' REQUIREMENTS:
'   - Workbook must contain a sheet named "Exceptions Report"
'   - Data must start at row 3 in that sheet
'   - Department tabs must exist with exact names listed below
'
' DEPARTMENT TABS SUPPORTED:
'   ACCESSORIES | CHILDREN'S | C ATH | M ATH
'   MEN'S CASUAL&WORK | MEN'S BOOTS-DRESS-SANDAL
'   W ATH | WOMEN'S BOOTS | WOMEN'S DRESS
'   WOMEN'S JUNIOR | WOMEN'S TRAD SPORT & CASUAL | WOMENS SANDAL
' ============================================================

Sub CopyAllSamplesByBgrp()

    Dim wsSource As Worksheet
    Dim wsTarget As Worksheet
    Dim srcRow As Long, tgtRow As Long
    Dim bgrp As String, targetTab As String
    Dim bgrpMap As Object

    ' Use a Dictionary object to map BGRP codes to tab names
    Set bgrpMap = CreateObject("Scripting.Dictionary")

    ' --- ACCESSORIES ---
    bgrpMap("APRL") = "ACCESSORIES"
    bgrpMap("BAGS") = "ACCESSORIES"
    bgrpMap("MISC") = "ACCESSORIES"
    bgrpMap("PROM") = "ACCESSORIES"
    bgrpMap("SOX")  = "ACCESSORIES"

    ' --- CHILDREN'S ---
    bgrpMap("SCB")  = "CHILDREN'S"
    bgrpMap("SCC")  = "CHILDREN'S"
    bgrpMap("SCD")  = "CHILDREN'S"
    bgrpMap("SCS")  = "CHILDREN'S"
    bgrpMap("SINF") = "CHILDREN'S"

    ' --- CHILDREN'S ATHLETIC ---
    bgrpMap("SCBA") = "C ATH"
    bgrpMap("SCGA") = "C ATH"
    bgrpMap("SINA") = "C ATH"

    ' --- MEN'S ATHLETIC ---
    bgrpMap("SMAA") = "M ATH"
    bgrpMap("SMAB") = "M ATH"
    bgrpMap("SMAC") = "M ATH"
    bgrpMap("SMAF") = "M ATH"
    bgrpMap("SMAR") = "M ATH"
    bgrpMap("SMAT") = "M ATH"
    bgrpMap("SMAW") = "M ATH"

    ' --- MEN'S CASUAL & WORK ---
    bgrpMap("SMBC") = "MEN'S CASUAL&WORK"
    bgrpMap("SMCT") = "MEN'S CASUAL&WORK"
    bgrpMap("SMCU") = "MEN'S CASUAL&WORK"
    bgrpMap("SMCY") = "MEN'S CASUAL&WORK"
    bgrpMap("SWAC") = "MEN'S CASUAL&WORK"
    bgrpMap("SWCJ") = "MEN'S CASUAL&WORK"
    bgrpMap("SWCT") = "MEN'S CASUAL&WORK"
    bgrpMap("SWCU") = "MEN'S CASUAL&WORK"

    ' --- MEN'S BOOTS, DRESS & SANDAL ---
    bgrpMap("SMBU") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMBW") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMDT") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMDU") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMS")  = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMWA") = "MEN'S BOOTS-DRESS-SANDAL"

    ' --- WOMEN'S ATHLETIC ---
    bgrpMap("SWAA") = "W ATH"
    bgrpMap("SWAB") = "W ATH"
    bgrpMap("SWAF") = "W ATH"
    bgrpMap("SWAR") = "W ATH"
    bgrpMap("SWAT") = "W ATH"
    bgrpMap("SWAW") = "W ATH"

    ' --- WOMEN'S BOOTS ---
    bgrpMap("SWBT") = "WOMEN'S BOOTS"
    bgrpMap("SWBJ") = "WOMEN'S BOOTS"
    bgrpMap("SWBU") = "WOMEN'S BOOTS"

    ' --- WOMEN'S DRESS ---
    bgrpMap("SWDJ") = "WOMEN'S DRESS"
    bgrpMap("SWDT") = "WOMEN'S DRESS"
    bgrpMap("SWDU") = "WOMEN'S DRESS"

    ' --- WOMEN'S JUNIOR ---
    bgrpMap("SWPJ") = "WOMEN'S JUNIOR"
    bgrpMap("SWSJ") = "WOMEN'S JUNIOR"

    ' --- WOMEN'S TRAD SPORT & CASUAL ---
    bgrpMap("SWPT") = "WOMEN'S TRAD SPORT & CASUAL"
    bgrpMap("SWPU") = "WOMEN'S TRAD SPORT & CASUAL"

    ' --- WOMEN'S SANDAL ---
    bgrpMap("SWST") = "WOMENS SANDAL"
    bgrpMap("SWSU") = "WOMENS SANDAL"

    ' -------------------------------------------------------
    ' MAIN LOOP: Read Exceptions Report and route each row
    ' -------------------------------------------------------
    Set wsSource = ThisWorkbook.Sheets("Exceptions Report")
    Application.ScreenUpdating = False  ' Speeds up macro execution

    For srcRow = 3 To 3000  ' Start at row 3 (assumes rows 1-2 are headers)
        bgrp = Trim(wsSource.Cells(srcRow, 5).Value)  ' Column E = BGRP code
        If bgrp = "" Then Exit For  ' Stop at first empty BGRP cell

        If bgrpMap.exists(bgrp) Then
            targetTab = bgrpMap(bgrp)
            Set wsTarget = ThisWorkbook.Sheets(targetTab)

            ' Find the next empty row in the target tab
            tgtRow = wsTarget.Cells(wsTarget.Rows.Count, 1).End(xlUp).Row + 1

            ' Copy columns A through T from source to target
            wsTarget.Range("A" & tgtRow & ":T" & tgtRow).Value = _
                wsSource.Range("A" & srcRow & ":T" & srcRow).Value
        End If

    Next srcRow

    Application.ScreenUpdating = True  ' Restore normal screen behavior
    MsgBox "Done! All samples have been routed to their department tabs.", vbInformation

End Sub
