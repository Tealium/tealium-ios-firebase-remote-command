# variable declarations
XCFRAMEWORK_PATH="tealium-xcframeworks"
ZIP_PATH="tealium.xcframework.zip"

# zip all the xcframeworks
function zip_xcframeworks {
    if [[ -d "${XCFRAMEWORK_PATH}" ]]; then
        zip -r "${ZIP_PATH}" "${XCFRAMEWORK_PATH}"
        rm -rf "${XCFRAMEWORK_PATH}"
    fi
}

surmagic xcf

zip_xcframeworks


echo ""
echo "Done! Upload ${ZIP_PATH} to GitHub when you create the release."
