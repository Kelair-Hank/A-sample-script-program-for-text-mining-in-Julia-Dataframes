# The following directory may need to be changed each time.
cd("C:\\Document D\\基绪康生物\\Projects\\Global_baseline_statistics\\India")
pwd()

using DataFrames, CSV, XLSX, Pipe, JLD2
core_test=@pipe XLSX.readtable("core_test.xlsx","Sheet1") |> DataFrame(_...)
therapy_type=@pipe XLSX.readtable("therapy type drug list cleaned.xlsx","Sheet1") |> DataFrame(_...)
unique!(therapy_type,Symbol[:Type,:Class])
select!(therapy_type,:Type,:Class)
core_test=coalesce.(core_test,"")

incorrect_rows=Int64[]
for i=1:nrow(core_test)
    drug_classes=split(core_test."Treatment Therapy class"[i],"+")
    drug_classes=string.(drug_classes)
    drug_classes=strip.(drug_classes)
    for j=1:nrow(therapy_type), k=drug_classes
        if (k==therapy_type.Class[j])&&(core_test."Treatment Therapy type"[i] != therapy_type.Type[j])&&(core_test."Treatment Therapy type"[i] != "")
            push!(incorrect_rows,i)
        end
    end
end

unique!(incorrect_rows)
incorrect_rows=incorrect_rows .+ 1
@save "incorrect_rows.jld2" incorrect_rows
println(incorrect_rows)
