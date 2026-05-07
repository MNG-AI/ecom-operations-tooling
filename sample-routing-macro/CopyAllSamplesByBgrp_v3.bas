' ============================================================
' Module:   CopyAllSamplesByBgrp_Clean (v3)
' Author:   Stanley Carter
' Version:  3.0 — adds On Hand inventory sync after routing
' Purpose:  Routes sample data from "Exceptions Report" to the
'           correct department tab by BGRP code, removes duplicates,
'           then syncs On Hand values from the source report back
'           to each department tab and highlights any changes.
'
' CHANGES FROM v2:
'   - Calls RefreshOnHandFromExceptions() as a third post-step
'   - SWAC reclassified from MEN'S CASUAL&WORK to W ATH
'   - SWCJ reclassified from MEN'S CASUAL&WORK to WOMEN'S JUNIOR
'   - SWCT reclassified from MEN'S CASUAL&WORK to WOMEN'S TRAD SPORT & CASUAL
'   - SWCU reclassified from MEN'S CASUAL&WORK to WOMEN'S TRAD SPORT & CASUAL
'   - Updated completion message reflects all three steps
' ============================================================
' EXECUTION ORDER:
'   1. CopyAllSamplesByBgrp_Clean  → routes rows to department tabs
'   2. RemoveDuplicatesButKeepNotes → deduplicates by Ecom Color # (Col M)
'   3. RefreshOnHandFromExceptions  → syncs Col S (On Hand) values,
'                                     highlights changed cells yellow
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
    ' NOTE: SWAC, SWCJ, SWCT, SWCU reclassified vs v2 (see header)
    bgrpMap("SMBC") = "MEN'S CASUAL&WORK"
    bgrpMap("SMCT") = "MEN'S CASUAL&WORK"
    bgrpMap("SMCU") = "MEN'S CASUAL&WORK"
    bgrpMap("SMCY") = "MEN'S CASUAL&WORK"

    ' --- MEN'S BOOTS, DRESS & SANDAL ---
    bgrpMap("SMBU") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMBW") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMDT") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMDU") = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMS")  = "MEN'S BOOTS-DRESS-SANDAL"
    bgrpMap("SMWA") = "MEN'S BOOTS-DRESS-SANDAL"

    ' --- WOMEN'S ATHLETIC (SWAC added in v3) ---
    bgrpMap("SWAA") = "W ATH"
    bgrpMap("SWAB") = "W ATH"
    bgrpMap("SWAF") = "W ATH"
    bgrpMap("SWAR") = "W ATH"
    bgrpMap("SWAT") = "W ATH"
    bgrpMap("SWAW") = "W ATH"
    bgrpMap("SWAC") = "W ATH"  ' moved from MEN'S CASUAL&WORK

    ' --- WOMEN'S BOOTS ---
    bgrpMap("SWBT") = "WOMEN'S BOOTS"
    bgrpMap("SWBJ") = "WOMEN'S BOOTS"
    bgrpMap("SWBU") = "WOMEN'S BOOTS"

    ' --- WOMEN'S DRESS ---
    bgrpMap("SWDJ") = "WOMEN'S DRESS"
    bgrpMap("SWDT") = "WOMEN'S DRESS"
    bgrpMap("SWDU") = "WOMEN'S DRESS"

    ' --- WOMEN'S JUNIOR (SWCJ added in v3) ---
    bgrpMap("SWPJ") = "WOMEN'S JUNIOR"
    bgrpMap("SWSJ") = "WOMEN'S JUNIOR"
    bgrpMap("SWCJ") = "WOMEN'S JUNIOR"  ' moved from MEN'S CASUAL&WORK

    ' --- WOMEN'S TRAD SPORT & CASUAL (SWCT, SWCU added in v3) ---
    bgrpMap("SWPT") = "WOMEN'S TRAD SPORT & CASUAL"
    bgrpMap("SWPU") = "WOMEN'S TRAD SPORT & CASUAL"
    bgrpMap("SWCT") = "WOMEN'S TRAD SPORT & CASUAL"  ' moved from MEN'S CASUAL&WORK
    bgrpMap("SWCU") = "WOMEN'S TRAD SPORT & CASUAL"  ' moved from MEN'S CASUAL&WORK

    ' --- WOMEN'S SANDAL ---
    bgrpMap("SWST") = "WOMENS SANDAL"
    bgrpMap("SWSU") = "WOMENS SANDAL"

    ' -------------------------------------------------------
    ' STEP 1: Route rows from Exceptions Report to dept tabs
    ' -------------------------------------------------------
    Set wsSource = ThisWorkbook.Sheets("Exceptions Report")
    Application.ScreenUpdating = False

    Dim lastRow As Long
    lastRow = wsSource.Cells(wsSource.Rows.Count, "A").End(xlUp).Row

    For srcRow = 3 To lastRow
        bgrp = Trim(wsSource.Cells(srcRow, 5).Value)  ' Column E = BGRP
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
    ' STEP 2: Remove duplicates by Ecom Color # (Column M)
    ' -------------------------------------------------------
    Call RemoveDuplicatesButKeepNotes

    ' -------------------------------------------------------
    ' STEP 3: Sync On Hand values from Exceptions Report
    ' -------------------------------------------------------
    Call RefreshOnHandFromExceptions

    Application.ScreenUpdating = True

    MsgBox "Sample routing completed." & vbCrLf & _
           "All tabs updated, duplicates removed, and On Hand values refreshed.", _
           vbInformation, "Update Complete"

End Sub


' ============================================================
' Module:   RemoveDuplicatesButKeepNotes
' Purpose:  Removes duplicate rows from each department tab
'           using Ecom Color # (Column M) as the unique key.
'           Deduplication range is A:V, preserving notes in
'           columns U and V.
' ============================================================

Sub RemoveDuplicatesButKeepNotes()

    Dim targetTabs As Variant
    Dim tabName As Variant
    Dim ws As Worksheet
    Dim lastRow As Long

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

        If lastRow > 2 Then
            ' Columns:=13 = Column M (Ecom Color #) is the dedup key
            ws.Range("A2:V" & lastRow).RemoveDuplicates Columns:=13, Header:=xlNo
        End If
    Next tabName

End Sub


' ============================================================
' Module:   RefreshOnHandFromExceptions
' Purpose:  Reads On Hand values (Column S) from the Exceptions
'           Report, then updates matching rows in department tabs
'           where the Ecom Color # (Column M) matches.
'           Changed cells are highlighted yellow for visibility.
'
' WHY THIS EXISTS:
'   After routing, On Hand inventory values in department tabs
'   may be stale. This syncs them back from the source report
'   so buyers and content ops are working from current data.
' ============================================================

Sub RefreshOnHandFromExceptions()

    ' Build a lookup: Ecom Color # → On Hand value
    Dim exceptionWS As Worksheet
    Set exceptionWS = ThisWorkbook.Sheets("Exceptions Report")

    Dim onHandDict As Object
    Set onHandDict = CreateObject("Scripting.Dictionary")

    Dim lastRow As Long, row As Long
    Dim ecomColor As String, onHandVal As Variant

    lastRow = exceptionWS.Cells(exceptionWS.Rows.Count, "A").End(xlUp).Row

    For row = 3 To lastRow
        ecomColor = Trim(exceptionWS.Cells(row, 13).Value)  ' Column M = Ecom Color #
        onHandVal = exceptionWS.Cells(row, 19).Value         ' Column S = On Hand
        If ecomColor <> "" Then
            onHandDict(ecomColor) = onHandVal
        End If
    Next row

    ' Apply updated On Hand values to each department tab
    Dim tabs As Variant, tabName As Variant
    Dim ws As Worksheet
    Dim checkRow As Long, wsLastRow As Long
    Dim currentVal As Variant

    tabs = Array( _
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

    For Each tabName In tabs
        Set ws = ThisWorkbook.Sheets(tabName)
        wsLastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

        For checkRow = 2 To wsLastRow
            ecomColor = Trim(ws.Cells(checkRow, 13).Value)

            If onHandDict.exists(ecomColor) Then
                currentVal = ws.Cells(checkRow, 19).Value

                ' Only update and flag if the value has changed
                If currentVal <> onHandDict(ecomColor) Then
                    ws.Cells(checkRow, 19).Value = onHandDict(ecomColor)
                    ws.Cells(checkRow, 19).Interior.Color = RGB(255, 255, 0)  ' Yellow highlight
                End If
            End If
        Next checkRow
    Next tabName

End Sub
