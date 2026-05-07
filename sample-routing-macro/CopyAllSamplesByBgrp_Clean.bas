' ============================================================
' Module:   CopyAllSamplesByBgrp_Clean
' Author:   Stanley Carter
' Version:  2.0 — adds automatic duplicate removal after routing
' Purpose:  Routes sample data from "Exceptions Report" to the
'           correct department tab by BGRP code, then removes
'           duplicate entries based on Ecom Color # (Column M).
'
' CHANGES FROM v1:
'   - Uses lastRow detection instead of hardcoded 3000-row limit
'   - Calls RemoveDuplicatesButKeepNotes() after routing
'   - Preserves columns U and V (notes fields) during dedup
'   - Added completion message with dedup confirmation
' ============================================================
' HOW IT WORKS:
'   1. Reads each row in "Exceptions Report" from row 3 to last row
'   2. Maps BGRP code (Column E) to the correct department tab
'   3. Copies columns A:T to the matching tab
'   4. After all rows are routed, scans every department tab
'      and removes duplicate rows where Column M (Ecom Color #) matches
'
' REQUIREMENTS:
'   - Workbook must contain a sheet named "Exceptions Report"
'   - Data starts at row 3 (rows 1-2 are title/header rows)
'   - Department tabs must exist with exact names listed below
'   - Columns U and V are preserved (not part of dedup range)
' ============================================================

Sub CopyAllSamplesByBgrp_Clean()

    Dim wsSource As Worksheet
    Dim wsTarget As Worksheet
    Dim srcRow As Long, tgtRow As Long
    Dim bgrp As String, targetTab As String
    Dim bgrpMap As Object

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
    ' MAIN LOOP: Route each row to the correct department tab
    ' -------------------------------------------------------
    Set wsSource = ThisWorkbook.Sheets("Exceptions Report")
    Application.ScreenUpdating = False

    ' Dynamically detect last row instead of hardcoding a limit
    Dim lastRow As Long
    lastRow = wsSource.Cells(wsSource.Rows.Count, "A").End(xlUp).Row

    For srcRow = 3 To lastRow
        bgrp = Trim(wsSource.Cells(srcRow, 5).Value)  ' Column E = BGRP code
        If bgrp = "" Then Exit For

        If bgrpMap.exists(bgrp) Then
            targetTab = bgrpMap(bgrp)
            Set wsTarget = ThisWorkbook.Sheets(targetTab)
            tgtRow = wsTarget.Cells(wsTarget.Rows.Count, 1).End(xlUp).Row + 1
            wsTarget.Range("A" & tgtRow & ":T" & tgtRow).Value = _
                wsSource.Range("A" & srcRow & ":T" & srcRow).Value
        End If
    Next srcRow

    ' -------------------------------------------------------
    ' POST-ROUTING: Remove duplicates from all department tabs
    ' -------------------------------------------------------
    Call RemoveDuplicatesButKeepNotes

    Application.ScreenUpdating = True

    MsgBox "Sample routing completed." & vbCrLf & _
           "All tabs updated and duplicates removed by Ecom Color #.", _
           vbInformation, "Update Complete"

End Sub


' ============================================================
' Module:   RemoveDuplicatesButKeepNotes
' Purpose:  After routing, removes duplicate entries in each
'           department tab based on Ecom Color # (Column M).
'           Operates on columns A:V so notes in U and V are
'           included in the range but NOT used as dedup keys.
'
' NOTE:     This subroutine is called automatically by
'           CopyAllSamplesByBgrp_Clean — no need to run it
'           manually unless troubleshooting a specific tab.
' ============================================================

Sub RemoveDuplicatesButKeepNotes()

    Dim targetTabs As Variant
    Dim tabName As Variant
    Dim ws As Worksheet
    Dim lastRow As Long

    ' All department tabs that receive routed data
    targetTabs = Array( _
        "ACCESSORIES", _
        "CHILDREN'S", _
        "C ATH", _
        "M ATH", _
        "MEN'S CASUAL&WORK", _
        "MEN'S BOOTS-DRESS-SANDAL", _
        "W ATH", _
        "WOMEN'S BOOTS", _
        "WOMEN'S DRESS", _
        "WOMEN'S JUNIOR", _
        "WOMEN'S TRAD SPORT & CASUAL", _
        "WOMENS SANDAL" _
    )

    For Each tabName In targetTabs
        Set ws = ThisWorkbook.Sheets(tabName)
        lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

        ' Only run dedup if there is data beyond the header row
        If lastRow > 2 Then
            ' Columns:=13 targets Column M (Ecom Color #) as the dedup key
            ' Range A:V ensures notes columns U and V are preserved
            ws.Range("A2:V" & lastRow).RemoveDuplicates Columns:=13, Header:=xlNo
        End If
    Next tabName

End Sub
