# ============================================================
# Fix HTML files - update lowercase .mjs references to match
# the mixed-case filenames that actually exist in the repo.
#
# HOW TO USE:
#   1. Open PowerShell
#   2. cd into the ROOT of your cloned mysite git repo
#   3. Run: .\fix-html-references.ps1
#
# Safe to run multiple times. Only touches HTML files.
# ============================================================

Write-Host "Scanning HTML files for outdated lowercase references..." -ForegroundColor Cyan

# These are ALL the files that were renamed to mixed-case.
# Script replaces any lowercase reference in HTML with the correct name.
$renames = [ordered]@{
    "rolldown-runtime.hbrq4igt.mjs"                                                    = "rolldown-runtime.hBrq4iGT.mjs"
    "react.bhvdichp.mjs"                                                               = "react.Bhvdichp.mjs"
    "motion.bjj5krmt.mjs"                                                              = "motion.Bjj5KRmt.mjs"
    "framer.e_h4lsrr.mjs"                                                              = "framer.E_h4lsrr.mjs"
    "phosphor.cjxzhwjq.mjs"                                                            = "Phosphor.CjXZHWjq.mjs"
    "wt4xk6wyf.bbyzwq3i.mjs"                                                           = "Wt4XK6WYf.BbyZwq3I.mjs"
    "xiwmsdpiu.cygizlb8.mjs"                                                           = "XiwmsdpiU.CYgIZlB8.mjs"
    "blxn69a46.dipphuk8.mjs"                                                           = "bLxN69a46.DippHUk8.mjs"
    "udh9bontj.0ccv15xq.mjs"                                                           = "uDh9bONtj.0Ccv15xq.mjs"
    "fss03h6vk.bvfwe2ks.mjs"                                                           = "FsS03h6Vk.BVfwe2KS.mjs"
    "adamepysa.bb2cwj0t.mjs"                                                           = "aDaMEpysA.Bb2Cwj0t.mjs"
    "ymtdkmibu.cmo66utp.mjs"                                                           = "YMtdKmiBu.CMO66uTp.mjs"
    "eqdmnbqxl.dfhnxvh3.mjs"                                                           = "eqDmnbQxL.DFHnXvh3.mjs"
    "udh9bontj.axd9a_ua.mjs"                                                           = "uDh9bONtj.AxD9A_uA.mjs"
    "migiy1hwj.c9kpw4mo.mjs"                                                           = "MIGIY1hWj.C9KPW4Mo.mjs"
    "eh2cu6ekoeo1uddb5b4ka5_tw1ggwr6acytbtegcz_w.btf4o2py.mjs"                        = "eh2Cu6ekoEO1uddB5B4ka5_tW1GgWr6acytBtEgCZ_w.BTF4o2PY.mjs"
    "zrm2pwvwa.cqc69iea.mjs"                                                           = "ZRM2PWVwA.CqC69IeA.mjs"
    "video.bq8ru-se.mjs"                                                               = "Video.BQ8Ru-se.mjs"
    "sxue_g8sa.ydfw5okr.mjs"                                                           = "sxUe_G8Sa.Ydfw5okR.mjs"
    "augia20il.rj-ipkd5.mjs"                                                           = "augiA20Il.Rj-IpKD5.mjs"
    "gjm1hubun.cug58bfb.mjs"                                                           = "gJm1Hubun.CUG58bFB.mjs"
    "fss03h6vk.doaiojih.mjs"                                                           = "FsS03h6Vk.DOAiOJIH.mjs"
    "erdjzzqhr.cgtwwwqk.mjs"                                                           = "ERDJzzQHr.CgtwWwqk.mjs"
    "script_main.d59vcpgw.mjs"                                                         = "script_main.D59VcPGw.mjs"
    "shared-lib.dshoobus.mjs"                                                          = "shared-lib.DSHoObUs.mjs"
    "tmueglxdc.ddpjvm4s.mjs"                                                           = "TMUEGlXDC.DDPJVM4S.mjs"
    "lrcho4necjgnp4egptxidrg4l_4mmjsjzrguzbuiye0.bkjlhjlz.mjs"                       = "LRCHO4nEcjGnp4EgptXidrg4L_4mMJSJzrguzbUiYe0.BKjlHJlZ.mjs"
    "vjvtiqxe3.bsjnqonm.mjs"                                                           = "VjvTIQXE3.BSJnQONM.mjs"
    "ejzrtlbp5pqccaks6gq-gwldumfosk9gytjoew9oc30.b8bw-zel.mjs"                        = "EjzrTLBp5pqcCAKs6GQ-gwldumFosk9gYTjoEw9oC30.B8bW-ZEL.mjs"
    "yb_wxsk4v.dfzkvvcf.mjs"                                                           = "Yb_WXsK4v.DFzKvVCF.mjs"
    "yjrhgbeeuyjqdwiogxxwngeqnfq16piubwgpm5m6ves.bsesrsql.mjs"                        = "YjRHGBEEUYJQDwioGxxWNgEqNfq16Piubwgpm5m6ves.BsESrSQL.mjs"
    "aqdzovswe.ckmehgwy.mjs"                                                           = "AQdzOvSwE.CKMeHgWy.mjs"
    "1wboiddaxutg_aax8yqqnl1rilokcogtznoi9yzmzt0.st68mnff.mjs"                        = "1wBOiDDAxUTg_AaX8YQqNl1rilokcoGtzNoi9YzMZt0.sT68MNfF.mjs"
    "eqdmnbqxl.bix_w2vt.mjs"                                                          = "eqDmnbQxL.Bix_w2VT.mjs"
    "izrhiehic.0rbzdnpz.mjs"                                                           = "iZRHiEHic.0RbzdnpZ.mjs"
    "5mlpsbih9mkwbvr_zesmatzqlgw1k9cuwebyw22cupa.duj5qnob.mjs"                        = "5mLpsbih9mkWbVR_ZESMATzQLgw1k9CuwEByW22cuPA.DuJ5qnob.mjs"
    "px9hioivm.cea7ro4y.mjs"                                                           = "PX9hIOIVM.CEa7ro4Y.mjs"
}

$htmlFiles = Get-ChildItem -Path . -Recurse -Filter "*.html" |
             Where-Object { $_.FullName -notmatch "\\.git\\" }

if ($htmlFiles.Count -eq 0) {
    Write-Host ""
    Write-Host "ERROR: No HTML files found." -ForegroundColor Red
    Write-Host "Make sure you are running this from the ROOT of your git repo." -ForegroundColor Yellow
    Write-Host "Example: cd C:\Users\msfro\Documents\GitHub\mysite" -ForegroundColor Yellow
    exit 1
}

Write-Host "Found $($htmlFiles.Count) HTML files." -ForegroundColor Gray

$totalUpdated = 0

foreach ($htmlFile in $htmlFiles) {
    $content = Get-Content $htmlFile.FullName -Raw -Encoding UTF8
    $original = $content

    foreach ($pair in $renames.GetEnumerator()) {
        $content = $content -creplace [regex]::Escape($pair.Key), $pair.Value
    }

    if ($content -ne $original) {
        Set-Content -Path $htmlFile.FullName -Value $content -Encoding UTF8 -NoNewline
        $rel = $htmlFile.FullName.Replace((Get-Location).Path + "\", "")
        Write-Host "  Updated: $rel" -ForegroundColor Green
        $totalUpdated++
    }
}

Write-Host ""
if ($totalUpdated -eq 0) {
    Write-Host "No HTML files needed updating — all references already correct." -ForegroundColor Cyan
} else {
    Write-Host "$totalUpdated HTML file(s) updated." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Committing and pushing..." -ForegroundColor Yellow
    git add -A
    git commit -m "fix: update HTML files to use correct mixed-case .mjs filenames"
    git push
    Write-Host ""
    Write-Host "Done! Wait ~60 seconds for GitHub Pages to redeploy." -ForegroundColor Green
}