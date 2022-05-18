#NoEnv

class ItemLogLayer {
    hbm :=
    hdc :=
    obm :=
    G :=
    ItemLogLayerHwnd :=

    __new(ByRef settings) {
        SetFormat Integer, D
        gameClientArea := getWindowClientArea()
        gameWindowX := gameClientArea["X"]
        gameWindowY := gameClientArea["Y"]
        gameWindowWidth := gameClientArea["W"]
        gameWindowHeight := gameClientArea["H"]

        Gui, ItemLog: -Caption +E0x20 +E0x80000 +E0x00080000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs 
        this.ItemLogLayerHwnd := WinExist()

        if ((gameWindowWidth / gameWindowHeight) > 2) { ;if ultrawide
            this.leftMargin := gameWindowX + 5 ; padding
            this.topMargin := gameWindowY + (gameWindowHeight / 12)
        } else {
            this.leftMargin := gameWindowX + (gameWindowHeight / 10) + 5
            this.topMargin := gameWindowY + (gameWindowHeight / 12)
        }
        
        this.itemLogFontSize := settings["itemLogFontSize"]
        this.textBoxWidth := 450
        this.textBoxHeight := this.itemLogFontSize * 10
        this.xoffset := 0
        this.yoffset := 0
        ; this.leftMargin := gameWindowX + 5 ; padding
        ; this.topMargin := gameWindowY + (gameWindowHeight / 10)

        pToken := Gdip_Startup()
        DetectHiddenWindows, On
        this.hbm := CreateDIBSection(this.textBoxWidth, this.textBoxHeight)
        this.hdc := CreateCompatibleDC()
        this.obm := SelectObject(this.hdc, this.hbm)
        this.G := Gdip_GraphicsFromHDC(this.hdc)
        Gdip_SetSmoothingMode(this.G, 4)
        Gdip_SetInterpolationMode(this.G, 7)
        Gui, ItemLog: Show, NA
    }

    drawItemLog() {
        if (!settings["itemLogEnabled"]) {
            Gui, ItemLog: Hide
            return
        }
        if (WinActive(gameWindowId)) {
            Gui, ItemLog: Show, NA
        } else {
            Gui, ItemLog: Hide
			return
        }
        if (readUI(d2rprocess)) {
             Gui, ItemLog: Hide
			return
        }
        fontSize := this.itemLogFontSize
        row := 0
        for kk, item in itemLogItems {
            ;OutputDebug, % item.itemLogText " " (A_Now - item.foundTime) "`n"
            if (!item.droppedOffList) {
                if ((A_Now - item.foundTime) < 12) {
                    
                    this.drawData(this.xoffset, this.yoffset + (row * (fontSize + 8)), fontSize, item.alertColor, item.itemLogText)
                    row++
                } else {
                    item.droppedOffList := true ; don't show on the drop list anymore`
                }
            }
        }

        UpdateLayeredWindow(this.ItemLogLayerHwnd, this.hdc, this.leftMargin, this.topMargin, this.textBoxWidth, this.textBoxHeight)
        Gdip_GraphicsClear( this.G )
    }

    drawData(textx, texty, fontSize, alertColor, itemText) {
        Options = x%textx% y%texty% Left vTop NoWrap c%alertColor% r4 s%fontSize%
        textx := textx + 1
        texty := texty + 1
        Options2 = x%textx% y%texty% Left vTop NoWrap cdd000000 r4 s%fontSize%
        Gdip_TextToGraphics(this.G, itemText, Options2, exocetFont)
        Gdip_TextToGraphics(this.G, itemText, Options, exocetFont)
    }

    hide() {
        Gui, ItemLog: Hide
    }

    delete() {
        SelectObject(this.hdc, this.obm)
        DeleteObject(this.hbm)
        DeleteDC(this.hdc)
        Gui, ItemLog: Destroy
    }
}
