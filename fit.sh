enlist=$1
outf=$2

echo "en,sigma_abs,zero,err_sigma_abs,peak_abs,err_peak_abs" > $outf

for en in $(cat $enlist);
do
  root FitAmp_3x3_$en.root << EOF

    ofstream outf("$outf", std::ios::app);
    .L ~/Downloads/dcb.cxx
    FitAmp_3x3_${en}_uncalibrated->Draw()
    FitAmp_3x3_${en}_uncalibrated->GetXaxis()->SetRangeUser(670/30. * $en*0.95, 670/30. * $en*1.05);
    FitAmp_3x3_${en}_uncalibrated->GetXaxis()->SetRangeUser(FitAmp_3x3_${en}_uncalibrated->GetMean() - 4*FitAmp_3x3_${en}_uncalibrated->GetRMS(), FitAmp_3x3_${en}_uncalibrated->GetMean() + 4*FitAmp_3x3_${en}_uncalibrated->GetRMS())
    FitAmp_3x3_${en}_uncalibrated->GetXaxis()->SetRangeUser(FitAmp_3x3_${en}_uncalibrated->GetMean() - 4*FitAmp_3x3_${en}_uncalibrated->GetRMS(), FitAmp_3x3_${en}_uncalibrated->GetMean() + 4*FitAmp_3x3_${en}_uncalibrated->GetRMS())
    dcb(FitAmp_3x3_${en}_uncalibrated)
    dcb(FitAmp_3x3_${en}_uncalibrated)
    dcb(FitAmp_3x3_${en}_uncalibrated)
    auto *f = FitAmp_3x3_${en}_uncalibrated->GetFunction("dcb")
    outf << ${en} << "," << f->GetParameter(5) << ",0," << f->GetParError(5) << "," << f->GetParameter(4) << "," << f->GetParError(4) << endl;
    outf.close()
    FitAmp_3x3_${en}_uncalibrated->SaveAs("FitAmp_3x3_${en}_fitted.root");
EOF
done


