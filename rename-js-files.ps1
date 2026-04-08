# ============================================================
# Framer Export - Fix Mixed-Case Filenames for GitHub Pages
#
# HOW TO USE:
#   1. Open PowerShell
#   2. cd into the ROOT of your cloned mysite git repo
#      e.g.   cd "C:\Users\msfro\Documents\GitHub\mysite"
#   3. Run:  .\rename-js-files.ps1
#      (copy this script into that folder first if needed)
# ============================================================

Write-Host "Starting rename process..." -ForegroundColor Cyan

# We use a 3-step rename to work around Windows case-insensitivity:
#   old_lowercase.mjs  ->  old_lowercase.mjs.tmp  ->  CorrectMixedCase.mjs

$renames = @(
    @("js/rolldown-runtime.hbrq4igt.mjs",                                                    "js/rolldown-runtime.hBrq4iGT.mjs"),
    @("js/react.bhvdichp.mjs",                                                               "js/react.Bhvdichp.mjs"),
    @("js/motion.bjj5krmt.mjs",                                                              "js/motion.Bjj5KRmt.mjs"),
    @("js/framer.e_h4lsrr.mjs",                                                              "js/framer.E_h4lsrr.mjs"),
    @("js/phosphor.cjxzhwjq.mjs",                                                            "js/Phosphor.CjXZHWjq.mjs"),
    @("js/wt4xk6wyf.bbyzwq3i.mjs",                                                          "js/Wt4XK6WYf.BbyZwq3I.mjs"),
    @("js/xiwmsdpiu.cygizlb8.mjs",                                                          "js/XiwmsdpiU.CYgIZlB8.mjs"),
    @("js/blxn69a46.dipphuk8.mjs",                                                          "js/bLxN69a46.DippHUk8.mjs"),
    @("js/udh9bontj.0ccv15xq.mjs",                                                          "js/uDh9bONtj.0Ccv15xq.mjs"),
    @("js/fss03h6vk.bvfwe2ks.mjs",                                                          "js/FsS03h6Vk.BVfwe2KS.mjs"),
    @("js/adamepysa.bb2cwj0t.mjs",                                                          "js/aDaMEpysA.Bb2Cwj0t.mjs"),
    @("js/ymtdkmibu.cmo66utp.mjs",                                                          "js/YMtdKmiBu.CMO66uTp.mjs"),
    @("js/eqdmnbqxl.dfhnxvh3.mjs",                                                          "js/eqDmnbQxL.DFHnXvh3.mjs"),
    @("js/udh9bontj.axd9a_ua.mjs",                                                          "js/uDh9bONtj.AxD9A_uA.mjs"),
    @("js/migiy1hwj.c9kpw4mo.mjs",                                                          "js/MIGIY1hWj.C9KPW4Mo.mjs"),
    @("js/eh2cu6ekoeo1uddb5b4ka5_tw1ggwr6acytbtegcz_w.btf4o2py.mjs",                       "js/eh2Cu6ekoEO1uddB5B4ka5_tW1GgWr6acytBtEgCZ_w.BTF4o2PY.mjs"),
    @("js/zrm2pwvwa.cqc69iea.mjs",                                                          "js/ZRM2PWVwA.CqC69IeA.mjs"),
    @("js/video.bq8ru-se.mjs",                                                              "js/Video.BQ8Ru-se.mjs"),
    @("js/sxue_g8sa.ydfw5okr.mjs",                                                          "js/sxUe_G8Sa.Ydfw5okR.mjs"),
    @("js/augia20il.rj-ipkd5.mjs",                                                          "js/augiA20Il.Rj-IpKD5.mjs"),
    @("js/gjm1hubun.cug58bfb.mjs",                                                          "js/gJm1Hubun.CUG58bFB.mjs"),
    @("js/fss03h6vk.doaiojih.mjs",                                                          "js/FsS03h6Vk.DOAiOJIH.mjs"),
    @("js/erdjzzqhr.cgtwwwqk.mjs",                                                          "js/ERDJzzQHr.CgtwWwqk.mjs"),
    @("js/script_main.d59vcpgw.mjs",                                                        "js/script_main.D59VcPGw.mjs"),
    @("js/shared-lib.dshoobus.mjs",                                                         "js/shared-lib.DSHoObUs.mjs"),
    @("js/tmueglxdc.ddpjvm4s.mjs",                                                          "js/TMUEGlXDC.DDPJVM4S.mjs"),
    @("js/lrcho4necjgnp4egptxidrg4l_4mmjsjzrguzbuiye0.bkjlhjlz.mjs",                      "js/LRCHO4nEcjGnp4EgptXidrg4L_4mMJSJzrguzbUiYe0.BKjlHJlZ.mjs"),
    @("js/vjvtiqxe3.bsjnqonm.mjs",                                                          "js/VjvTIQXE3.BSJnQONM.mjs"),
    @("js/ejzrtlbp5pqccaks6gq-gwldumfosk9gytjoew9oc30.b8bw-zel.mjs",                       "js/EjzrTLBp5pqcCAKs6GQ-gwldumFosk9gYTjoEw9oC30.B8bW-ZEL.mjs"),
    @("js/yb_wxsk4v.dfzkvvcf.mjs",                                                          "js/Yb_WXsK4v.DFzKvVCF.mjs"),
    @("js/yjrhgbeeuyjqdwiogxxwngeqnfq16piubwgpm5m6ves.bsesrsql.mjs",                       "js/YjRHGBEEUYJQDwioGxxWNgEqNfq16Piubwgpm5m6ves.BsESrSQL.mjs"),
    @("js/aqdzovswe.ckmehgwy.mjs",                                                          "js/AQdzOvSwE.CKMeHgWy.mjs"),
    @("js/1wboiddaxutg_aax8yqqnl1rilokcogtznoi9yzmzt0.st68mnff.mjs",                       "js/1wBOiDDAxUTg_AaX8YQqNl1rilokcoGtzNoi9YzMZt0.sT68MNfF.mjs"),
    @("js/eqdmnbqxl.bix_w2vt.mjs",                                                         "js/eqDmnbQxL.Bix_w2VT.mjs"),
    @("js/izrhiehic.0rbzdnpz.mjs",                                                         "js/iZRHiEHic.0RbzdnpZ.mjs"),
    @("js/5mlpsbih9mkwbvr_zesmatzqlgw1k9cuwebyw22cupa.duj5qnob.mjs",                       "js/5mLpsbih9mkWbVR_ZESMATzQLgw1k9CuwEByW22cuPA.DuJ5qnob.mjs"),
    @("js/px9hioivm.cea7ro4y.mjs",                                                          "js/PX9hIOIVM.CEa7ro4Y.mjs")
)

$successCount = 0
$skipCount    = 0
$errorCount   = 0

foreach ($pair in $renames) {
    $old = $pair[0]
    $new = $pair[1]
    $tmp = "$old.tmp"

    if (-Not (Test-Path $old)) {
        Write-Host "  SKIP (not found): $old" -ForegroundColor Yellow
        $skipCount++
        continue
    }

    Write-Host "  $old" -ForegroundColor Gray
    Write-Host "  --> $new" -ForegroundColor Green

    try {
        # Step 1: rename to a completely different .tmp name (avoids Windows case-insensitivity)
        Rename-Item -Path $old -NewName (Split-Path $tmp -Leaf) -ErrorAction Stop

        # Step 2: rename from .tmp to the correct mixed-case final name
        Rename-Item -Path $tmp -NewName (Split-Path $new -Leaf) -ErrorAction Stop

        $successCount++
    } catch {
        Write-Host "  ERROR: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
Write-Host "Done!  Renamed: $successCount  |  Skipped: $skipCount  |  Errors: $errorCount" -ForegroundColor Cyan

if ($errorCount -eq 0 -and $successCount -gt 0) {
    Write-Host ""
    Write-Host "Staging and committing changes..." -ForegroundColor Cyan

    # Tell git to be case-sensitive so it picks up the renames
    git config core.ignorecase false
    git add js/
    git commit -m "fix: restore original mixed-case filenames for GitHub Pages ES module compatibility"
    git push

    Write-Host ""
    Write-Host "All done! Pushed to GitHub." -ForegroundColor Green
    Write-Host "Wait ~60 seconds for GitHub Pages to redeploy, then test your site." -ForegroundColor Green
} elseif ($successCount -eq 0 -and $skipCount -gt 0) {
    Write-Host ""
    Write-Host "No files were found. Make sure you are running this script from" -ForegroundColor Red
    Write-Host "the ROOT of your cloned git repo (the folder that contains the js/ folder)." -ForegroundColor Red
    Write-Host "Example:  cd C:\Users\msfro\Documents\GitHub\mysite" -ForegroundColor Yellow
    Write-Host "Then run: .\rename-js-files.ps1" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Review any errors above. Then run:" -ForegroundColor Yellow
    Write-Host "  git config core.ignorecase false" -ForegroundColor White
    Write-Host "  git add js/" -ForegroundColor White
    Write-Host "  git commit -m 'fix: restore mixed-case filenames'" -ForegroundColor White
    Write-Host "  git push" -ForegroundColor White
}
