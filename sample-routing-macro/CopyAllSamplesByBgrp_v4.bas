' ============================================================
' Module:   CopyAllSamplesByBgrp_Clean (v4)
' Author:   Stanley Carter
' Version:  4.0 — major expansion: live formulas, visual flags,
'           sort, and buyer-facing column management
' Purpose:  Routes sample data from "Exceptions Report" to dept
'           tabs, then applies formulas, visual highlights, sorting,
'           duplicate removal, and column visibility controls.
'
' CHANGES FROM v3:
'   - Column S: replaced static On Hand copy with live VLOOKUP
'     formula pointing back to Exceptions Report
'   - Column W: adds Keep Priority formula (1 if notes exist, else 0)
'   - Column U: stamps the date each row was added
'   - New rows highlighted light blue (full row A:W)
'   - On Hand < 100 flagged pink in Column S
'   - RefreshOnHandFromExceptions() removed (replaced by VLOOKUP)
'   - New subroutine: SortByEcomColorAndPriority()
'   - New subroutine: HideBuyerColumns()
'   - Execution order changed: Sort → Dedup → Hide Columns
' ============================================================
' EXECUTION ORDER:
'   1. CopyAllSamplesByBgrp_Clean  → routes rows, applies formulas,
'                                    highlights new rows and low inventory
'   2. SortByEcomColorAndPriority  → sorts each tab by Col M asc, Col W desc
'   3. RemoveDuplicatesButKeepNotes → deduplicates by Ecom Color # (Col M)
'   4. HideBuyerColumns            → hides internal-only columns from view
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
    bgrpMap("SWAC") = "W ATH"

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
    bgrpMap("SWCJ") = "WOMEN'S JUNIOR"

    ' --- WOMEN'S TRAD SPORT & CASUAL ---
    bgrpMap("SWPT") = "WOMEN'S TRAD SPORT & CASUAL"
    bgrpMap("SWPU") = "WOMEN'S TRAD SPORT & CASUAL"
    bgrpMap("SWCT") = "WOMEN'S TRAD SPORT & CASUAL"
    bgrpMap("SWCU") = "WOMEN'S TRAD SPORT & CASUAL"

    ' --- WOMEN'S SANDAL ---
    bgrpMap("SWST") = "WOMENS SANDAL"
    bgrpMap("SWSU") = "WOMENS SANDAL"

    ' -------------------------------------------------------
    ' STEP 1: Route rows and apply per-row enrichments
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

            ' Copy base data (columns A through T)
            wsTarget.Range("A" & tgtRow & ":T" & tgtRow).Value = _
                wsSource.Range("A" & srcRow & ":T" & srcRow).Value

            ' Column S (19): Live VLOOKUP back to Exceptions Report
            ' Returns On Hand value; shows "N/A" if no match found
            wsTarget.Cells(tgtRow, 19).Formula = _
                "=IFERROR(VLOOKUP(M" & tgtRow & ",'Exceptions Report'!M:S,7,FALSE),""N/A"")"

            ' Column W (23): Keep Priority flag
            ' Returns 1 if Column V (notes) is not empty, else 0
            ' Used as secondary sort key to surface reviewed items
            wsTarget.Cells(tgtRow, 23).Formula = "=IF(V" & tgtRow & "<>"""",1,0)"

            ' Column U (21): Date this row was added to the tab
            wsTarget.Cells(tgtRow, 21).Value = Date

            ' Highlight entire new row light blue for visibility
            wsTarget.Range("A" & tgtRow & ":W" & tgtRow).Interior.Color = RGB(173, 216, 230)

            ' Low inventory alert: highlight Column S pink if On Hand < 100
            ' Brief wait allows VLOOKUP to resolve before evaluation
            Application.Wait (Now + TimeValue("0:00:01"))
            If IsNumeric(wsTarget.Cells(tgtRow, 19).Value) Then
                If wsTarget.Cells(tgtRow, 19).Value < 100 Then
                    wsTarget.Cells(tgtRow, 19).Interior.Color = RGB(255, 192, 203)  ' Pink
                End If
            End If

        End If
    Next srcRow

    ' -------------------------------------------------------
    ' STEP 2: Sort each tab by Ecom Color # then Keep Priority
    ' -------------------------------------------------------
    Call SortByEcomColorAndPriority

    ' -------------------------------------------------------
    ' STEP 3: Remove duplicates by Ecom Color # (Column M)
    ' -------------------------------------------------------
    Call RemoveDuplicatesButKeepNotes

    ' -------------------------------------------------------
    ' STEP 4: Hide buyer-internal columns from department views
    ' -------------------------------------------------------
    Call HideBuyerColumns

    Application.ScreenUpdating = True

    MsgBox "Sample routing complete. Tabs updated, new rows flagged, and duplicates removed.", _
           vbInformation, "Update Complete"

End Sub


' ============================================================
' Module:   SortByEcomColorAndPriority
' Purpose:  Sorts each department tab by:
'             Primary:   Column M (Ecom Color #) — ascending
'             Secondary: Column W (Keep Priority) — descending
'           This surfaces reviewed/flagged items within each
'           color group.
' ============================================================

Sub SortByEcomColorAndPriority()

    Dim targetTabs As Variant, tabName As Variant
    Dim ws As Worksheet, lastRow As Long

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
            With ws.Sort
                .SortFields.Clear
                .SortFields.Add Key:=ws.Range("M2:M" & lastRow), Order:=xlAscending   ' Ecom Color #
                .SortFields.Add Key:=ws.Range("W2:W" & lastRow), Order:=xlDescending  ' Keep Priority
                .SetRange ws.Range("A2:W" & lastRow)
                .Header = xlNo
                .Apply
            End With
        End If
    Next tabName

End Sub


' ============================================================
' Module:   RemoveDuplicatesButKeepNotes
' Purpose:  Removes duplicate rows in each department tab using
'           Ecom Color # (Column M) as the unique key.
'           Operates on range A:V to preserve columns U and V.
' ============================================================

Sub RemoveDuplicatesButKeepNotes()

    Dim targetTabs As Variant, tabName As Variant
    Dim ws As Worksheet, lastRow As Long

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
            ws.Range("A2:V" & lastRow).RemoveDuplicates Columns:=13, Header:=xlNo  ' Column M
        End If
    Next tabName

End Sub


' ============================================================
' Module:   HideBuyerColumns
' Purpose:  Hides internal/buyer-facing columns that aren't
'           needed in the department content view.
'           Resets all column visibility first to avoid stacking
'           hidden columns across multiple runs.
'
' Hidden columns: A, C, D, G, K, O, P, Q, R, T
' ============================================================

Sub HideBuyerColumns()

    Dim tabName As Variant, ws As Worksheet
    Dim colsToHide As Variant, colRef As Variant

    ' Columns to hide from content/ops view
    colsToHide = Array("A", "C", "D", "G", "K", "O", "P", "Q", "R", "T")

    For Each tabName In Array( _
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
        Set ws = ThisWorkbook.Sheets(tabName)

        ' Reset: unhide all columns before applying new visibility
        ws.Columns.Hidden = False

        ' Hide specified columns
        For Each colRef In colsToHide
            ws.Columns(colRef).Hidden = True
        Next colRef
    Next tabName

End Sub
