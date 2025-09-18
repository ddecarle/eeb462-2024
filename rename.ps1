# rename.ps1

# Define the old and new names
$oldNames = "Ursus Dasypus Erinaceus Didelphis Ornithorhynchus Lepus Macropus Oryctolagus Crocuta Mus Equus Microtus Macaca Cavia Pteropus Canis Acinonyx Rattus"
$newNames = "bear armadillo hedgehog opossum platypus hare wallaby rabbit hyaena mouse horse vole macaque guineaPig flyingFox dingo cheetah rat"

# Split the strings into arrays
$old = $oldNames -split " "
$new = $newNames -split " "

# Get the count of old names
$count = $old.Count

# Loop through the arrays and perform the renaming using regular expressions
for ($i = 0; $i -lt $count; $i++) {
    
    # Build the regular expression pattern
    $oldName = $old[$i]
    $newName = $new[$i]
    $pattern = "^.*" + [regex]::Escape($oldName) + ".*$"
    $replacement = ">" + $newName

    # Read the file content
    $filePath = "18s.fasta"
    try {
        $content = Get-Content -Path $filePath
    }
    catch {
        Write-Error "Could not read file: $($filePath)"
        continue  # Skip to the next iteration
    }

    # Perform the replacement using regex
    $newContent = foreach ($line in $content) {
        $line -replace $pattern, $replacement
    }

    # Write the new content back to the file
    try {
        $newContent | Set-Content -Path $filePath
    }
    catch {
        Write-Error "Could not write to file: $($filePath)"
        continue  # Skip to the next iteration
    }
}

# -----
