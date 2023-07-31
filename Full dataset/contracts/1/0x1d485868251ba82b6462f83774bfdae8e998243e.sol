/**
 *Submitted for verification at Etherscan.io on 2021-09-22
*/

// File: @openzeppelin/contracts/utils/Strings.sol



pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

// File: cdata.sol


pragma solidity ^0.8.0;


contract CCData {
    using Strings for uint256;
    string a =
        "<svg xmlns='http://www.w3.org/2000/svg' width='512' height='512' viewBox='0 0 512 512'><defs><style>.bg{fill:";
    string[] b = ["#8c0000", "#000000", "#003103"];
    string c =
        ";}.b{fill:#e49a38;}.c,.g{fill:none;stroke:#000;stroke-miterlimit:10;}.c{stroke-width:6px;}.d{fill:#823b00;}.e{fill:#e8b46c;}.f{fill:#fff;}.g{stroke-width:2px;}</style></defs><rect class='bg' width='512' height='512' /><path class='b' d='M467.31,8.43H7V501.07H504.51V8.43Zm27.9,457h6.2V498H468.86v-6.2h26.35Zm-1.55,24.8h-24.8v-12.4h12.4v-12.4h12.4ZM10.09,465.42h6.2v26.35H42.64V498H10.09Zm7.75,24.8v-24.8h12.4v12.4h12.4v12.4ZM16.29,44.08h-6.2V11.53H42.64v6.2H16.29Zm1.55-24.8h24.8v12.4H30.24v12.4H17.84Zm462.38,24.8H468.86V32.71h11.36Zm0,1.55V463.87H467.31v12.92H44.19V463.87H31.28V45.63H44.19V32.71H467.31V45.63Zm0,419.79v11.37H468.86V465.42Zm-448.94,0H42.64v11.37H31.28Zm0-421.34V32.71H42.64V44.08Zm12.91-12.4V19.28H467.31v12.4Zm-13.95,14V463.87H17.84V45.63Zm14,432.19H467.31v12.4H44.19Zm437.07-13.95V45.63h12.4V463.87Zm0-419.79V31.68h-12.4V19.28h24.8v24.8Zm-12.4-26.35v-6.2h32.55V44.08h-6.2V17.73Zm-1.55-6.2v6.2H44.19v-6.2ZM10.09,45.63h6.2V463.87h-6.2ZM44.19,498v-6.2H467.31V498Zm457.22-34.1h-6.2V45.63h6.2Z' /><path class='c' d='M490.82,290.3l-9-81.29s-40-1.14-117.78,5.86c-55.71,5-84.4,8.9-96.2,10.71-1.21-25-19.17-32.57-42.88-43-27.39-12.09-37.37-34-60.93-34.89-28.39-1.06-65.1,59-70.55,65.76S34.73,269.7,25.12,305.1c-5.87,21.63,3.21,27.64,9.12,29.2a13.18,13.18,0,0,0,9.82-1.36c39.06-22.05,90.3-22.73,90.3-22.73-3.92,46.52,16.39,36,16.39,36s51-10.95,84.62-42.54C303.23,296.1,436.09,283,490.82,290.3Z' /><path class='b' d='M134.36,310.21s-51.24.68-90.3,22.73a13.18,13.18,0,0,1-9.82,1.36c-5.91-1.56-15-7.57-9.12-29.2,9.61-35.4,62.88-84.93,68.33-91.68S135.61,146.6,164,147.66c23.56.88,33.54,22.8,60.93,34.89,33.47,14.76,55.48,23.74,35.1,84.18s-109.28,79.51-109.28,79.51S130.44,356.73,134.36,310.21Z' /><path class='d' d='M44.06,332.94c39.06-22.05,90.3-22.73,90.3-22.73s10.4-67.31,22.22-105.48S160.27,158,160.27,158s-5.09-7.41-1.31,19.11c2,14-3.89,12.59-5.12-8.56-.2-3.36-4.5,2.21-2.36,5.77s9.94,47.72-23.61,84.18c-14.85,16.14-20.28,15.15-39.71,34.14S44.06,332.94,44.06,332.94Z' /><path class='d' d='M259.19,267.91c20.38-60.44-1.64-69.42-35.1-84.18,0,0,33.14,14.25,36.75,27.4s-.66,74.76-96.69,111c-71.52,27,38.26,39.79,94-51.41Z' /><path class='e' d='M217.69,280.41s-54.38,37.31-65.28,28.82,19.87-145.58,19.87-145.58S156.37,297.56,217.69,280.41Z' /><path class='e' d='M135.09,172.07s-73.8,83.52-81.56,104.05S60,308.3,74.23,273.8C92.87,228.58,135.09,172.07,135.09,172.07Z' /><path class='f' d='M261.1,226.69c-2.81,20.59-17.24,54.88-67.1,81.9,0,0,221.8-28.27,296.82-18.29l-9-81.29s-40-1.14-117.78,5.86S261.1,226.69,261.1,226.69Z' />";
    string[] d = [
        "<path class='b' d='M244.34,438l-1.66,4.42a8.94,8.94,0,0,1-2.38-1.18,72.24,72.24,0,0,1-5.34-5.45c-.88-1-1.62-1.19-2.27,0a8.05,8.05,0,0,0-.77,2.71,2,2,0,0,1-1.61,2c.3-2.37.28-4.62.91-6.66,1.6-5.11.43-9.49-2.83-13.52-2.32-2.87-3.9-6-3.19-9.86.34-1.84,1-2.15,2.41-1,2.67,2.12,5.19,4.43,7.9,6.5a6.49,6.49,0,0,0,2.94.8c1.15.16,2.53-.31,2.83,1.47.22,1.37-.44,2.45-2,3.17l-1.35.58a12.43,12.43,0,0,0,6.38,4.47c1.9.67,3.84,1.22,5.73,1.92,4.51,1.67,6.4,4.5,6.33,9.33-.05,3.14.06,3.24,3.19,2.76,7.23-1.12,12-6.28,12.92-13.54A23.13,23.13,0,0,0,268.13,410c3.1,2.11,7.36,10.73,5.76,18.18-1,4.9-3.17,9.19-7.22,12.37s-8.75,3.82-13.88,3.59c-.1,1.28-.11,2.47-.3,3.63-.08.45-.56,1.18-.88,1.19-2.75.1-5.5.06-8.25.06l-.09-.54,4.59-.69c-2.63-2.78-3.86-5.88-2.91-9.6ZM231.76,416.9c.41-.61.88-1,.83-1.34s-.58-.62-.91-.93c-.33.35-.84.66-.92,1.07S231.28,416.35,231.76,416.9Z' /><path class='b' d='M234.3,440.09c2.95.38,5.19,2.07,7.58,3.41.17.09.18.94,0,1.09a1.81,1.81,0,0,1-1.38.41c-.48-.14-.84-.68-1.27-1C237.62,442.7,236,441.44,234.3,440.09Z' /><path class='b' d='M230.81,428.67c.41,2.32-1.05,4.57-2.82,4.31C228.75,431.45,228.68,429.48,230.81,428.67Z' />;",
        "<path class='b' d='M225.55,419.88a17.36,17.36,0,0,1-1.59,2.17c-1,.92-2.06,1.71-3,2.63a7.36,7.36,0,0,0-1.32,1.72c-.81,1.48-1.8,1.67-2.91.42a5,5,0,0,1-1-4.89c.63-2.41,1.16-4.84,1.74-7.33-1.69-1.13-4.16-1.13-4.79-3.64a16,16,0,0,0,3.06.58,4.7,4.7,0,0,0,2.44-.69c1.33-.86,1.24-1.53-.1-2.45a2.06,2.06,0,0,1-.86-1l5.42,2a5.66,5.66,0,0,0-.61,1.2c-.13.61-.37,1.66-.14,1.78.6.35,1.71.67,2.11.35a10.59,10.59,0,0,0,3-3.21c.85-1.6.11-2.72-1.74-3.08s-3.65-.58-5.48-.87l.16-.73,7.76,2a3.73,3.73,0,0,0,1.26.2c4-.48,7.76.66,11.53,1.91,4.67,1.55,9.45,2.77,14.2,4.08a20.09,20.09,0,0,1,8.58,4.37c2.08,1.91,4.58,1.89,7,.76s3.7-3.43,4.13-6.09c.06-.38-.26-.81-.35-1.22-.25-1.12-.46-2.24-.74-3.64,1.95,1.08,2.42,2.52,2,5-1,5.39-3,7.17-9.3,8.16a58.48,58.48,0,0,0,.6,6.78,5.59,5.59,0,0,0,1.92,2.63,6.74,6.74,0,0,1,2.59,4.92,18.22,18.22,0,0,0,1.73,5.5c1.06,2.53.61,3.75-2.33,4.94-.54-2.13-1.4-4.2-1.52-6.32-.14-2.48-1.76-3.25-3.47-4.27,0,.24-.11.41-.06.47,3.17,3.47.74,7.65,1.31,11.45.05.33-1.66,1.16-2.63,1.35-1.21.24-1.18-.87-1.09-1.66.26-2.42.64-4.83.9-7.24,0-.51-.08-1.34-.41-1.54a13.63,13.63,0,0,1-5.23-5.73,3.68,3.68,0,0,0-4.28-2.19c-2,.33-3.91.77-5.89,1.05-2.52.35-5.06.57-7.59.92-.45.06-1.15.36-1.25.7a74.25,74.25,0,0,0-2.07,8.15A55.26,55.26,0,0,0,237,446c0,.62-.42,1.65-.82,1.74a10.66,10.66,0,0,1-3.43,0,5.82,5.82,0,0,1,0-1.86c.6-4.31,1.38-8.6,1.84-12.92.23-2.21-.78-2.8-2.72-1.69a30.29,30.29,0,0,0-3.83,3.1,39,39,0,0,1,3.51,4.3c.92,1.54.55,3.27,0,5.48-1-1.08-1.64-1.73-2.19-2.5a60.13,60.13,0,0,0-3.48-5c-1.39-1.56-1.23-3-.38-4.61a14.29,14.29,0,0,0,1.3-8.71C226.44,422.28,226,421.33,225.55,419.88Zm-3.65-5.82c-.53.66-1.11,1.07-1.08,1.43a1.46,1.46,0,0,0,1,1c.33,0,.95-.56,1-.95S222.36,414.76,221.9,414.06Z' />",
        "<path class='b' d='M230.42,430.87c-.92-4.54-.37-9.42-6.4-11.27,2.06,2.82,4.11,5.15,3.86,8.61-1.62-.82-3.18-1.53-4.63-2.42-.36-.22-.34-1.05-.5-1.6l-.75-2.74-.47.16-.42,4.22-.69,0-.36-2.36-.43-.19a8.45,8.45,0,0,0-.9,2.29c-.1,1.16-.25,2.05-1.63,2.25a2.12,2.12,0,0,0-1,.77c-1,1.11-2,1.13-3.07,0l.86-1.9a6,6,0,0,1-1.2.28c-.46,0-1.11.05-1.32-.21s-.06-.89,0-1.34c.2-1,.46-2,.69-3s.56-2.13.76-3.21c.25-1.36.41-2.75.63-4.27.36.1.85.08,1,.29,1.35,2,3,1.25,4.59.5a2.6,2.6,0,0,1,3.06.36,22.72,22.72,0,0,0,3.45,1.84c1.47.74,3,1.46,4.39,2.16.14-1.2-.11-1.48-2.88-3.2-1.35-.84-2.67-1.72-4-2.57.22-.39.25-.54.33-.59,2.91-1.78,2.89-1.74,5.33.54,3.66,3.43,4.16,7.59,2.94,12.18C231.34,427.77,230.94,429.07,230.42,430.87Zm-12.61-11.12.18.67a9.74,9.74,0,0,0,2.86-.53c.46-.23.7-1.23.71-1.89,0-.4-.66-1.18-.92-1.14a2.86,2.86,0,0,0-1.4,1A22.61,22.61,0,0,0,217.81,419.75Z' /><path class='b' d='M258.61,412.5c4.08,1.52,6.54,4.6,6,7.48-.08.48-.77.87-1.18,1.3l-.77-.07c.83,2.5,1.38,5.17,2.6,7.46,1,1.84.45,2.55-1,3.31a10.92,10.92,0,0,0-1.17.79l.15.54a21.47,21.47,0,0,0,3.43-.68c1.15-.42,1.64-.12,1.81,1,.34,2.34.82,4.68,1,7a7.91,7.91,0,0,1-.71,3.91,3.2,3.2,0,0,1-2.45,1.22c-1.61.06-1.92-.81-1-2.16a6.66,6.66,0,0,0-2.12-9.12c-.71-.38-1.39-.83-2.38-1.42l2.4-3.49-.17-.45c-1.24.51-2.46,1.06-3.72,1.53-.45.16-1.23.36-1.41.15a1.92,1.92,0,0,1-.39-1.57c.51-1.92,1.21-3.8,1.74-5.72a2.89,2.89,0,0,0,0-2C257.56,418.68,258.31,415.68,258.61,412.5Z' /><path class='b' d='M234,429c.32,2,.79,3.77,2.55,5,.56.4.83,1.22,1.24,1.85a11.69,11.69,0,0,1-2.82,1.47c-.48.11-1.4-.58-1.74-1.14-2-3.29-1.23-6.55-.13-10,1.39-4.41,1-8.75-2.53-12.31-.72-.73-1.36-1.53-2-2.3l.26-.42,7.83,1.07a12.53,12.53,0,0,0,.47,2.77,29.56,29.56,0,0,0,2.75,6.23c1.73,2.55,1.36,5.34,1.62,8.08,0,.21-.59.49-.67.54a41.1,41.1,0,0,0-1.82-5.24,5.43,5.43,0,0,0-2.65-2c2.87,2.82,2.09,6.12,1.55,10Z' /><path class='b' d='M237.66,411.63l2-.48a20.83,20.83,0,0,0,4.44,10.38c-.69-2.48-1.42-4.94-2.06-7.43a4.92,4.92,0,0,1-.1-2.22,1.3,1.3,0,0,1,2.5-.24c1,2.56,1.94,5.13,2.71,7.76a7.21,7.21,0,0,1,0,3.1c-.29,1.65-.91,3.25-1.11,4.91-.16,1.36-.8,1.65-2.11,1.57,0-4.52-2.06-8.22-4.5-11.86C238.43,415.65,238.27,413.63,237.66,411.63Z' /><path class='b' d='M255.59,429.44A21,21,0,0,1,254,426a7.48,7.48,0,0,1-.12-3.16c.53-3-.47-5.62-1.93-8.17a33.2,33.2,0,0,1-1.58-3.75,3.17,3.17,0,0,1,.77-.27c4.36-.09,4.39.1,4.29,4.35a16.65,16.65,0,0,0,1,6.35C257.84,425.15,258,425.16,255.59,429.44Z' /><path class='b' d='M251.56,427.3l-2.95.42c-.11-.24-.23-.38-.2-.45,2-4.28.05-8.16-1.22-12.09-.46-1.42-1.06-2.78-1.6-4.2.25-.15.38-.3.54-.32,3-.4,2.88-.38,3.43,2.51.38,2,1,4,1.49,6,.45,1.81,1,3.61,1.23,5.44C252.39,425.29,251.91,426.08,251.56,427.3Z' /><path class='b' d='M252.91,434.21c1.3.06,2.4.08,3.48.19a1.25,1.25,0,0,1,.81.61c1.15,2.78-.22,7.95-2.71,9.64a5.41,5.41,0,0,1-2.81.53,1.64,1.64,0,0,1-1.17-.91c-.1-.23.37-.87.73-1.11,3.77-2.58,4.16-4.16,1.93-8.19A8,8,0,0,1,252.91,434.21Z' /><path class='b' d='M221.88,433.48c3.4.41,4.32,1,3.79,2.45l-2.43-1.42c.43,3.8-1.64,6.43-3.34,9.17a1.75,1.75,0,0,1-1.61.43,1.64,1.64,0,0,1-.69-1.46,25.91,25.91,0,0,1,1.61-4.33C220,436.7,220.93,435.17,221.88,433.48Z' /><path class='b' d='M233.67,438.8h4.05l.1,1.95-2.76.3a11.72,11.72,0,0,0,1.32.88,2.82,2.82,0,0,1,1.46,4,3.48,3.48,0,0,1-4.5,1.45,1.66,1.66,0,0,1-.42-1.26c2.39-1.78.81-4.14,1-6.23A5.3,5.3,0,0,0,233.67,438.8Z' /><path class='b' d='M227.59,434.13c-1.57-.69-2.87-1.19-4.08-1.84a1.82,1.82,0,0,1-.87-1.28,30.57,30.57,0,0,1,.31-3.42,10,10,0,0,1,5.39,3.42C229.45,432.43,228.25,433.35,227.59,434.13Z' /><path class='b' d='M257.42,433.27c-1.75,0-3.34,0-4.94,0a1.45,1.45,0,0,1-.91-.77c-.53-1-.95-2.13-1.41-3.19C252.74,427.91,257.27,430.47,257.42,433.27Z' /><path class='b' d='M266.34,419.7c2.05,2,2,2.7-.15,4C264.72,422.26,264.72,422.26,266.34,419.7Z' /><path class='b' d='M277.13,423.38c-1.4-.17-2.87.39-3.19-1.35-.07-.36.75-1.28,1.19-1.29C276.65,420.69,276.92,421.89,277.13,423.38Z' /><path class='b' d='M268.18,427.57l-1.55-2.44,2.17-1.08C270.06,425.46,270,425.83,268.18,427.57Z' /><path class='b' d='M275.06,428.69l-2.65.8c.24-1.11.4-1.88.56-2.66l2.28,1.29Z' />",
        "<path class='b' d='M239.56,416.79a22.43,22.43,0,0,0,6.47,5.52c1.53.9,3.12,1.73,4.73,2.48,4.36,2,8.15,4.58,9.07,9.94a7.59,7.59,0,0,1,2-.92,3.52,3.52,0,0,1,2.36.28,2.42,2.42,0,0,1,.13,2.19c-1.48,3.19-3.43,5.94-7.25,6.63-.23,0-.45.33-.64.54-.46.52-.81,1.37-1.37,1.53-3.4,1-6.85,1.82-10.28,2.7a1.41,1.41,0,0,1-.41,0c-.95,0-1.88-.13-2.13-1.29s.57-1.62,1.45-2c.63-.26,1.3-.43,1.94-.67l3.06-1.14c-2.91-1.06-6-1.6-8.44-3.23s-4.1-4.36-6.21-6.72a17.23,17.23,0,0,0,0,2.59,4.72,4.72,0,0,1-1.21,3.93c-.86,1-1.89.9-2.11-.37a39.71,39.71,0,0,1-.34-6.08,18.27,18.27,0,0,1,.31-2.64l-.44-.16a14.08,14.08,0,0,0-.87,1.68,5.35,5.35,0,0,1-2.83,3.19,1.66,1.66,0,0,1-1.5-.06c-.26-.25-.18-1,0-1.49a12.65,12.65,0,0,1,5.07-7.53,1.57,1.57,0,0,0,.53-1.16c-.1-1.86-.24-3.73-.49-5.58,0-.37-.62-.7-1-1-1.38-1.11-2.86-2.11-4.13-3.33s-1.29-2.06-.23-3.62a8.4,8.4,0,0,1,10.14-2.74,2.13,2.13,0,0,0,2.6-.28c2-1.6,4.06-3.09,6.07-4.67a7,7,0,0,1,6.18-1.4c1.55.36,3.11.73,4.63,1.18a6.38,6.38,0,0,1,1.48.87v.4a77.46,77.46,0,0,0-8.16,2.43,78.78,78.78,0,0,0-7.6,4.08l4,.2c2.09.11,4.21,0,6.27.34,3.36.5,6.52,5.21,5.88,8.85a16.51,16.51,0,0,1-1.31-1.18c-.88-1-1.66-2.06-2.6-3a8.79,8.79,0,0,0-5.5-2.49c-3.21-.31-6.41-.75-9.62-1.13-.4,0-.81-.07-1.33-.11a2.82,2.82,0,0,0,2.14,2.72c1.6.5,3.29.73,4.93,1.07l4.32.88-.07.39Zm-8.47-2.63c.58-.73,1.16-1.14,1.15-1.54s-.6-.81-.93-1.22c-.41.37-1,.68-1.16,1.12S230.61,413.37,231.09,414.16Z' />",
        "<path class='b' d='M218.61,415.87l2.28.64-2.09,8.19,2.17-.77.1,1.52.45.26,1.46-2.24.6.44a2.38,2.38,0,0,0-.55-3,1.78,1.78,0,0,1-.4-2.44,13,13,0,0,0,.61-1.52,2.5,2.5,0,0,1,2.5-1.9,2.92,2.92,0,0,0,2.11-1.36c.78-1.75-.53-3.22-2.42-2.82a24.34,24.34,0,0,0-3,1.12l-1.28-1.44a15,15,0,0,1,2.43-.26,2.68,2.68,0,0,0,2.87-1.43c.24-.57-.53-1.55-.86-2.39a6.05,6.05,0,0,0,1.88.39,7,7,0,0,0,3-.75c.3-.18-.09-1.49-.17-2.36l4.31.84.2-.58-3.7-4.19c3.67,1.22,6.57,4.32,10.88,2.71-.63-.37-1.05-.83-1.42-.8-1.63.13-2.33-.91-3-2.09a2.86,2.86,0,0,0-.89-.94c-2.07-1.35-2.07-1.34-2.54-4.24a10.7,10.7,0,0,0,.82.93c1.62,1.49,3.08,3.26,4.93,4.37a18.86,18.86,0,0,0,6.18,1.8L239.77,394l.17-.27c1,.76,2,1.46,2.87,2.28,2.05,1.83,4.05,3.72,6.11,5.62,1.6-1.51-.1-3,.22-4.72.74,2,2.41,3.26,1.6,5.5-.24.68.58,1.49,1.65,1.15a7.48,7.48,0,0,1,1.69-.44c-1.69,1.41-1,2.83-.41,4.33.38.95.2,2.2.74,3a21.29,21.29,0,0,0,3.08,3.07l1.63,1.62-.2.38c.59-.09,1.18-.13,1.75-.27,2.39-.59,3.09-2.25,1.23-4-1.62-1.48-1.51-1.59-1.13-2.77.64.85,1.29,1.88,2.09,2.77,1.51,1.64,1.3,3.32-.78,4.12a15.24,15.24,0,0,1-4,.76c-3.77.31-7.46.73-10.85,2.73-2.45,1.45-4.44.51-5.74-2.09a44.5,44.5,0,0,0-2.54-4c.8.65,1.64,1.26,2.37,2a4.48,4.48,0,0,1,.66,1.31c1.51,3,2.59,3.38,5.56,1.89a20.36,20.36,0,0,1,3.32-1.37,33.47,33.47,0,0,1,3.56-.66l-6.53-5.26-.33.25,3.65,4.65c-.89-.3-1.5-.33-1.82-.65-1.49-1.5-3-3-4.32-4.66-.9-1.08-1.89-.89-2.93-.56a3.38,3.38,0,0,0-1,.58c-.86-.26-1.33-.56-1.75-.5a14.63,14.63,0,0,0-8.21,4.12,20.37,20.37,0,0,0-6.75,15.46,25.23,25.23,0,0,0,.37,2.84l.86-.7a19.07,19.07,0,0,0,.58,1.89c.38.86.56,2,1.92,1.83,1.2-.18,2.18-.61,2.4-2.05.16-1,.51-2,.81-3.17l1.65,1.74c3-1.65,4-4.45,4.77-7.52,1.41,1.92,4,1.6,5.22-.45.42-.7.75-1.45,1.21-2.35.66,1.09.93,2.62,2.64,2l3.13-1.18c.38,1.74,1.28,2.34,3.66,2.22a3.2,3.2,0,0,0,2.85,3.29,3.44,3.44,0,0,0,1,3.95c.33.24.43.8.76,1.06a10.76,10.76,0,0,0,2.47,1.65c.26.11.9-.7,1.49-1.18l1,.46c1.26-.92,1.22-1.71.23-2.85a10.12,10.12,0,0,1-1.84-3.8l1.18,1.07-1.26-8.4.36-.06,2,5.83.49-.16v-7.62l.29,0,1.21,6.12.61,0,.78-5.73.26,0,.68,5.93.3.09.94-2.43.3,0c-.15,1.91-.3,3.82-.49,6.08l1.51-1.43.38.22c-1,1.65-2.08,3.29-3.11,4.95a11.41,11.41,0,0,0-1.21,2.07c-1.58,4.58-5.56,6.14-9.63,3.49a22.84,22.84,0,0,1-4.67-4.28c-2.67-3.11-7.08-3.29-10.18,0,3.11,1.65,3.81,5,5.42,7.81l1.12-1.79.69.33c.08,2.93,2,4.6,3.89,6.59l-3-.54-.34,2.75-.44.46L248.35,446l-1.08,1.89h-.39v-4.09c-1-1.58-2.17-3.49-3.49-5.27a2.68,2.68,0,0,0-1.89-.75c-2,0-3.85-.11-5-2.35.59,3.1-1.77,4-3.64,4.9a18.42,18.42,0,0,1-6.17,1.94c-4.2.41-7.15-1.93-8.62-6.28a23.12,23.12,0,0,1-.74-9.25,8.16,8.16,0,0,0,.11-1,5.26,5.26,0,0,1,.59-3.63C219.1,420.48,220,418.28,218.61,415.87Zm30.29-9.81c-.43.66-.83,1-.85,1.37s.55.83.73.78a1.34,1.34,0,0,0,.93-.81C249.77,407.1,249.32,406.71,248.9,406.06Z' /><path class='b' d='M232.56,414.69l-.38,3.43c3.57-1.1,6.26.27,8.47,2.93a7.87,7.87,0,0,0-.74-.32c-.28-.1-.58-.16-1-.27l.22,2.33-1.44-2-.5,2.24a8.58,8.58,0,0,0-.65-1.52c-1.69-2.28-1.38-2.22-3.77-1.42a4.65,4.65,0,0,1-1.56.44c-.71,0-1.77-.16-2-.61a2.64,2.64,0,0,1,0-2.31,24.44,24.44,0,0,1,2.7-3.18Z' /><path class='b' d='M227.63,447.11l-1.82-.66c.79-1,.79-1,3.45-.8.73-2.83.73-2.83,3.41-3.73l-.45,3.55,2.22,1c-3.07.07-2.62,3.51-4.7,4.52l-.41-2.14-3.34.94-.36-.34Z' />",
        "<path class='b' d='M261,420.37c-2.75,1.17-5.4,2.68-8.26,3.44A75.93,75.93,0,0,1,228,426.38c-6.85-.48-10.12-7-6.7-13.08,2.14-3.76,5.55-6.13,9.27-8,7.75-3.95,16.07-5.13,24.65-4.65a9.13,9.13,0,0,1,3.83,1.29c3.25,1.87,3.33,5.19.14,7.13a26.58,26.58,0,0,1-14.56,3.64c-.87,0-1.75-.08-2.61-.16a4.37,4.37,0,0,1-.85-.25,67,67,0,0,0,7.07-1.47,47.25,47.25,0,0,0,6.57-2.88c.49-.24,1.08-1.06,1-1.46a2.18,2.18,0,0,0-1.38-1.35,12.82,12.82,0,0,0-4-.27c-6.31.85-12.43,2.43-18,5.75a15.06,15.06,0,0,0-4.07,3.46,4.39,4.39,0,0,0-.8,3.53c.24.72,2,1.34,3,1.33,3.37,0,6.76-.28,10.12-.62,6.29-.64,12.56-1.5,18.86-2.05a21.1,21.1,0,0,1,6.47.55c3.12.71,4.46,4,2.47,6.48a15.15,15.15,0,0,1-5.57,4.34c-5.75,2.48-11.69,4.53-17.54,6.79-1.32.51-2.56,1.2-3.84,1.8l.11.58a7.49,7.49,0,0,0,1.25.45,15.45,15.45,0,0,0,1.8.18c5.19.37,6.75,3.68,4,7.95-.82.15-1.77.05-2,.43s-.07,1.33-.07,2.23c-1.33,1.12-2.94,2.21-5,1.1a2.29,2.29,0,0,1-1-1.86,28.47,28.47,0,0,1,1.8-3.95c.59-1.28,1.14-2.57,1.8-4.09-.64.07-.78,0-.82.09-.71.84-1.3,2.24-2.14,2.42a7.45,7.45,0,0,1-6-.9,3.32,3.32,0,0,1-.15-5.38,77.66,77.66,0,0,1,10.25-7c3.91-2.12,8.19-3.58,12.26-5.43a34.75,34.75,0,0,0,3.77-2.29Z' />",
        "<path class='b' d='M238.18,404.35c5.18,3.75,5.38,3.72,8.14-.76-.09,2-1.15,3.38-3.62,4.55a4.67,4.67,0,0,0,4.66,0c3.37-2.41,3.55-3.45,1.55-9.09,1,.7,1,.7,2.63,5.28,3-.58,3.34-3.3.86-6.58l.31-.28a7.63,7.63,0,0,1,1.5,1.75,22.74,22.74,0,0,1,.56,2.8c.15.53.47,1.3.84,1.38s1.1-.34,1.5-.71a32.49,32.49,0,0,1,2.58-2.66,6.38,6.38,0,0,1,2.93-.94c-2.5.68-3.93,2.52-5.1,4.59-.16.29.31.93.59,1.69,1.14-1.3,2.05-2.35,3-3.39a2.92,2.92,0,0,1,3.68-.74,9.61,9.61,0,0,1,4.56,13.1,3.22,3.22,0,0,1-3,1.93c-1.29,0-2.08-.62-2.84-2.16,3,2.34,5,1.55,5.9-2.27A8.39,8.39,0,0,0,265,402c-1.33-.7-2.47-.67-3.46.56-.68.83-1.32,1.7-2.06,2.47a1.65,1.65,0,0,0,0,2.58c1.71-.88,3-3.57,5.47-1.58a5,5,0,0,1,1.68,5.23,19,19,0,0,0-1.08-3.63c-1.05-2-2.66-2.17-4.24-.54a5.5,5.5,0,0,0-1.66,4.05c-.06,6-.57,12-3.23,17.68a26.93,26.93,0,0,0-2.2,16.5c.17.94.27,1.74-.95,1.86s-1.12-.88-1.16-1.62c-.13-2.93-.22-5.86-.32-8.8,0-.55,0-1.09,0-1.64l-.57-.15a4,4,0,0,0-.51,1.35c.11,3.61.2,7.23.49,10.83.1,1.31-.18,2-1.47,2.07s-2-.07-2.07-1.66c-.24-3.6-.76-7.17-1.14-10.77-.09-.93-.55-1.2-1.44-1.2a36.8,36.8,0,0,1-16.53-3.77c-1-.51-1.66-.38-2.18.65a3.68,3.68,0,0,1-1.07,1.31c-2.17,1.54-1.91,3.46-1.16,5.64.59,1.69.85,3.5,1.3,5.26.2.81.06,1.42-.87,1.39s-2,.45-2.35-1c-.85-3.37-1.76-6.73-2.54-10.13a2.16,2.16,0,0,1,.64-1.7c2-1.85,2.16-4.19,1.73-6.57a48.57,48.57,0,0,0-1.67-5.51c-1.22.12-2.51,1.66-3.93.14,3.12-3.19,5.93-6.46,10.93-6.85a42.9,42.9,0,0,1,16,2c.92.28,1.83.59,2.77.78,2.27.45,3.55-.26,4.53-2.39h-4.43v-.33l2.42-1.32c-3.92-.22-3.92-.22-2.93-3.68C241.5,410.46,239.79,407.71,238.18,404.35Zm16.39,2.49c-.52.62-1.1,1-1.09,1.4s.66,1.11.93,1.06a1.72,1.72,0,0,0,1.18-1C255.67,408,255.05,407.49,254.57,406.84Z' /><path class='b' d='M230,434.08a6.48,6.48,0,0,1-.83,1.18c-2.29,1.85-2.33,4-1,6.42a6.78,6.78,0,0,1,.3.79c.74,2,.51,2.4-1.67,2.55-.68-2.56-1.38-5.11-2-7.67a1.65,1.65,0,0,1,.15-1.22c.8-1.15,1.7-2.23,2.63-3.43Z' />",
        "<path class='b' d='M254.86,404.57l-.43-3.95.5-.24,3.23,4.26v-5l.53-.17a6.8,6.8,0,0,1,1.17,1.68,125,125,0,0,1,3.57,12.35c.48,2.45.08,5.12-.17,7.67-.54,5.26-1.21,10.51-1.89,15.76a35.94,35.94,0,0,1-1.22,6.28c-.24.77-1.42,1.4-2.31,1.76a1.87,1.87,0,0,1-1.74-.61,2.14,2.14,0,0,1,.14-2c2.61-2.7,1.91-5.92,1.57-9.08a12,12,0,0,0-.71-2.33c-2.31.83-3.5,2.27-3.53,4.34,0,2.94,0,5.88.06,8.82a7.8,7.8,0,0,0,.87,2.1c.24.65.4,1.33.6,2a8.06,8.06,0,0,1-2,.46c-2-.11-2.33-.58-2.38-2.51a36.64,36.64,0,0,0-1.81-11.61,3.79,3.79,0,0,1,.13-2c.2-.9.52-1.78.79-2.66l-.36-.19a9.24,9.24,0,0,1-1.34,1.88,2.86,2.86,0,0,1-1.93.8,24.45,24.45,0,0,1-4.67-1.27c-2.14-.79-4.21-1.76-6.39-2.68l.64-2.73c-2.4,3.34-4.84,6.42-6.85,9.76-.65,1.07-.28,2.84-.11,4.27a14.9,14.9,0,0,0,1,2.88,6,6,0,0,1,.68,2.39c-.05.36-1.24.71-2,.81-1,.14-2.1-.14-2.36-1.33-.41-1.84-.71-3.71-.94-5.58-.29-2.45-.59-4.87,1.12-7.09a3.19,3.19,0,0,0-.09-2.56,16,16,0,0,1-.57-8.68,5.29,5.29,0,0,0-.18-2.27c-1.18-3.95,1.17-8.39,4.92-9.22,3.24-.71,5,1.26,4.15,4.71a4.59,4.59,0,0,1-3,3.37c-.61.21-1.42-.2-2.14-.33a13.7,13.7,0,0,1,.6-2.22c.17-.38.67-.61,1.19-1.06a2.37,2.37,0,0,0-2.77,1.09c-.69,1-1.13,2.26-.13,3.17a4.22,4.22,0,0,0,2.83,1.13c1.83-.18,3-1.59,3.91-3.12.53-.94,1.06-1.41,2.22-1.13,3.25.78,6.53,1.46,9.8,2.19a5.68,5.68,0,0,0,6.08-1.89c.8-1,.88-1.66-.38-2.16-1.66-.66-3.34-1.25-5-1.93a3,3,0,0,1-2.07-2.36c1.85.29,3.53-.33,3.71-1.31.14-.74-.49-1-3-1.69Zm2.64,3.49c.41-.78.9-1.26.81-1.62s-.75-1-1.08-.91a1.46,1.46,0,0,0-1,1.09C256.27,407,256.88,407.37,257.5,408.06Z' /><path class='b' d='M238,431a1.77,1.77,0,0,1-.16.53c-2.43,2.93-1.67,6.11-.67,9.26.18.57.89,1,1.24,1.51a9.74,9.74,0,0,1,.7,1.65,5.44,5.44,0,0,1-1.51.49c-2.46.07-3-.25-3.55-2.73a34.85,34.85,0,0,1-1.29-8.16C232.82,429.93,234.51,429.19,238,431Z' />",
        "<path class='b' d='M237.18,445.46c1.44-4.87,2.81-9.94-.62-15.2-1.16,1.93-2.22,3.45-1.85,5.64a11.92,11.92,0,0,1-2.08,9.24c-.65.89-1.27,1.27-2.21.26-.37-.4-1.07-.48-1.95-.83,3.35-5.56,2.38-11.69,1.17-17.81,2-.5,3.78-.84,5.52-1.41a6.08,6.08,0,0,0,3.93-4l-2.9,1.71a10.79,10.79,0,0,1-10.31.64,44.74,44.74,0,0,0-6.28-1.93c-1.12-.29-1.71-.84-1.7-1.92,2.35,0,4.65-.11,6.93,0,1.43.1,1.77-.38,1.86-1.71a5.28,5.28,0,0,0-2-4.74c-1.2-1-1.82-2-.42-3.43a5.15,5.15,0,0,0,1.37-4.58c-.17-1.3.46-2.71.74-4.07l.54.06c.29,1,.55,2,.87,3,.41,1.31,1.17,1.78,2.47,1a2.84,2.84,0,0,1,1.3-.44,17.53,17.53,0,0,1,2.29.23c.35-1.59.58-3.76,2.55-5.12l3.22,6.33.5-.17c-.34-1.13-.67-2.27-1-3.54l1.84-.73c-.23.65-.37,1-.59,1.66l7.34-.39.12.41-2.71,1.25,7.56,2.72-2,.5-.14.51,7.06,3-1.67.12-.18.54,6,2-1.53.28c.11.2.16.41.27.46a21.54,21.54,0,0,0,3.07,1.17c5.13,1.2,7.51,4.91,8.69,9.61.74,3,.88,6-.71,8.79a12.92,12.92,0,0,1-.75,1.17c-.09.12-.27.17-.59.37a7.41,7.41,0,0,1,.42-5.27,6.68,6.68,0,0,0-1.72-8c-.71,1.67-1.49,3.37-2.15,5.12a2.71,2.71,0,0,0,.18,1.51c1.16,3.93,1.84,7.85.66,11.94a26.4,26.4,0,0,0-.4,4.49c-.13,1.24-.61,1.82-1.94,1a9.52,9.52,0,0,0-2.27-.66c.11-.58.26-1.36.43-2.12.28-1.3.65-2.59.86-3.9.43-2.72.41-5.19-2.58-6.77a13.48,13.48,0,0,1-3.46-3.37c-.65-.77-1.14-.72-2.06-.48a80.89,80.89,0,0,1-9.59,2.13c-2.56.36-3.5,1.36-3.53,4.07a48.37,48.37,0,0,1-.8,8.05,11.15,11.15,0,0,1-1.64,3.07Zm-5.51-31.41c.73-.89,1.43-1.38,1.39-1.8a1.78,1.78,0,0,0-1.18-1.27c-.4-.05-1.18.63-1.28,1.1S231.11,413.08,231.67,414.05Z' /><path class='b' d='M252.72,445.89l-3.37-1.39c.45-.86,1-1.91,1.55-2.95.36-.66.79-1.28,1.14-1.95.62-1.17,1.55-2.32,1.7-3.56s-.64-2.3-1.05-3.57c1.23-.51,2.48-1.06,3.76-1.51a1.31,1.31,0,0,1,1,.28,3.87,3.87,0,0,1,.62,4.82c-1.5,2.53-2.88,5.12-4.29,7.69C253.43,444.45,253.09,445.17,252.72,445.89Z' /><path class='b' d='M222.23,412.49c.36,1.26.82,2.63,1.12,4,.24,1.13-.15,1.94-1.52,1.88-.58,0-1.15,0-1.73,0-3.38-.15-4-.66-4.67-4-.31-1.45.12-2,1.55-1.95Z' />",
        "<path class='b' d='M273.77,442.21l-4.07-1.94c1.27-2.53,1.55-4.83-.12-6.91a7,7,0,0,0-2.56-1.75,7.38,7.38,0,0,0-2.32-.39c-3.07-.33-5.95-.93-6.95-4.7-.27,2.2-1.77,2-3.15,2.08-3.22.26-6.09-.82-8.89-2.23-1-.51-2.06-1-3.07-1.59a1.36,1.36,0,0,0-2.11.56,16.19,16.19,0,0,1-7.61,6.55,8.41,8.41,0,0,0-4.86,5.51c-1,3-1.67,6.11-3.94,8.51-1.87-1.91-1.9-3.73-.34-5.64a8.26,8.26,0,0,0,1.28-2.75c1.1-3.52,1.94-7.15,4.88-9.79,1-.89,1-2.11,1-3.48a27.7,27.7,0,0,1,.83-8.05c1.36-4.33,5.73-6,10-4.55a57.17,57.17,0,0,0,8.37,2.25c2.4.43,3.05-.21,3.82-2.57a30.68,30.68,0,0,1,6.13-10.67c.35-.4.67-.81,1-1.27-3.49-.87-9.68,4.18-10.33,8.41l1.71-.52A5.45,5.45,0,0,1,244.8,409l1.66.18c1.65.21,2.85,0,3.33-2.06.31-1.33,1.45-2.46,2.16-3.71a19.3,19.3,0,0,0,.83-2l8.9-3.5c-.08-1-.16-2.23-.26-3.54,4.88,3.93,9.89,7.25,13.25,12.34.74,1.12,1.19,1.92,0,2.94a2.21,2.21,0,0,1-3.09,0,14.68,14.68,0,0,0-3-1.45c-1-.4-2.05-.68-3.27-1.07a7.08,7.08,0,0,0-1.23,5.17c.22,2.78.62,5.55.73,8.34a21.82,21.82,0,0,1-.46,5.22c-.26,1.17,0,1.71,1.06,2.07.81.27,1.59.61,2.39.89a7,7,0,0,1,5.13,6.64C273.07,437.52,273.41,439.54,273.77,442.21Zm-7.24-41.3c-.47.74-1,1.18-.9,1.53s.62.79,1,.89c.2,0,.81-.59.8-.9S267,401.64,266.53,400.91Z' /><path class='b' d='M241.88,425.76c2.59,1.43,2.76,1.53,1.53,3.79-2,3.69-1.74,7.11.36,10.66a73.25,73.25,0,0,1,3.13,6.66c-1,0-1.67-.06-2.3,0-1.44.14-1.77-.55-2.2-1.89a43.09,43.09,0,0,0-3.29-7.23,7.78,7.78,0,0,1,.75-9.35C240.54,427.57,241.17,426.69,241.88,425.76Z' /><path class='b' d='M266,447.55a8.49,8.49,0,0,1-2.34.09,1.84,1.84,0,0,1-1.12-1.17c-.65-3.19-1.15-6.41-1.78-9.6-.35-1.77-.85-3.5-1.29-5.31,3.21.32,3.11.35,3.73,3.3.82,3.95,1.83,7.87,2.75,11.81A6.31,6.31,0,0,1,266,447.55Z' /><path class='b' d='M229.46,409.93a11.81,11.81,0,0,0-7.17,4.63c-2.27,2.89-4.63,5.71-7,8.64h3l.23.51-3.62,2.07-.24-.38,1.06-.92-3.28-1.08c3.79-2.22,5.94-5.64,8.39-8.77a11,11,0,0,1,6.79-4.53C228.2,410,228.83,410,229.46,409.93Z' /><path class='b' d='M224.82,426c-.24-1.69-.49-3.38-.75-5.2l-3.78,4.85-.31-.23c1.44-2.25,2.87-4.5,4.44-7l1,4.13,1.52-3,.3.11L225.15,426Z' />",
        "<path class='b' d='M251.09,444.59c3.23,0,6.75-.67,8.66,3.22a10.33,10.33,0,0,1-2-.18,21.82,21.82,0,0,0-8.59-.41c-3,.35-3.38-.28-2.36-3.1.62-1.73,1-3.55,1.48-5.34l-.52-.15c-.63,1.47-1.18,3-1.93,4.4a2.78,2.78,0,0,1-1.58,1.26c-2.1.49-4.23.79-6.36,1.17-7.94,1.42-16.34-6.23-15-15.43a31.64,31.64,0,0,1,7.45-16.41,16.28,16.28,0,0,0,1.36-1.74c1-1.46.48-2.51-1.23-2.81a16,16,0,0,1-1.86-.32,1.92,1.92,0,0,1-1.51-2.26,2.56,2.56,0,0,1,1.71-1.41c2.74-.59,5.16.32,6.28,2.15,1.4,2.3,1.19,4.53-.81,7-3.39,4.11-6.19,8.51-7,13.9a12.83,12.83,0,0,0,2.18,9.74,4.68,4.68,0,0,0,6,1.76c-4-4.54-4.53-9.87-3.52-15.53a12,12,0,0,1,5.81-8.43c1.65-1,3.31-2,4.92-3.13.81-.55,1.67-1.23.34-2.24a2,2,0,0,1,.42-.1l3,.39a11.6,11.6,0,0,0-.34-2.66,4,4,0,0,0-4-2.64c-.07-3.45,2.08-5.64,6.18-6.45,3.92-.77,6.69.75,8.17,4.59l-1,.28a18.15,18.15,0,0,0-2.86.85c-4.13,2-4.39,5.43-.54,8.35l-1.26-4.72a6.09,6.09,0,0,0,2.34-.08c.28-.15.14-1.12.2-2l1-.47c1.11,1.5,2,1.57,2.42-.51,1.83,2.46,1.27,3.78-2.15,5.32l0,.46,3.21-.15c.68,2.68-.22,3.56-5,4.26.19,1.36.31,2.73.58,4.09.45,2.26,1,4.51,1.5,6.75a6,6,0,0,0,.63,1.58c2,3.41,3.94,6.82,6,10.18a3.88,3.88,0,0,0,1.76,1.52c1.58.62,2.93,1.36,3.51,3.38-.54,0-1,0-1.39,0-.1,0-.19-.11-.29-.11-4.78-.3-6.55-4.72-9.72-7.2-.38-.29-.33-1.15-.44-1.75a43.56,43.56,0,0,0-1.08-5.86c-1.18-3.67-4.84-4.46-7.59-1.77-2.29,2.25-3,5.17-3.28,8.27a38.45,38.45,0,0,1,1.8-3.71,13.18,13.18,0,0,1,2.42-3.07c1.92-1.71,4-1.24,5.16,1.06a11.78,11.78,0,0,1,.73,7.42C252.57,438.61,251.81,441.4,251.09,444.59Z' />",
        "<path class='b' d='M224,421.23l1.28,4,.39,0,.58-1.12c1.43,3.28,2.88,4.43,5.53,4.29l-.74-2.45,1.63.41-.4-2a12,12,0,0,0,7,1.26l.3-.42-2.5-1.59.42-.44,2,.14-1-1.85c1.72.31,3.41.56,5.06.95a8,8,0,0,1,5.76,5.6c.33.95-.31,2.22-.45,3.35-.08.64,0,1.28-.07,1.92a6.14,6.14,0,0,0,1.69-1,4.17,4.17,0,0,0,1-4.3,3.48,3.48,0,0,1,1.84,4c0,.15-.14.31-.1.44.15.58.34,1.15.52,1.73.58-.37,1.51-.62,1.7-1.13a8.51,8.51,0,0,0-.58-7.65c-.68-1.11-1.57-2.1-2.36-3.14a5.5,5.5,0,0,1,7.23,1.57l-3.94-1.89-.39.54a7.94,7.94,0,0,1,4.22,5.3c.1.34.31.73.23,1a13.78,13.78,0,0,1-.79,1.81,14.05,14.05,0,0,1-1-1.31,6.33,6.33,0,0,0-1.34-1.82c-.07,1.37,0,2.76-.23,4.12-.25,1.8-.62,3.48-3,3.72-1.17.12-2.24,1.35-3.38,1.4a18.43,18.43,0,0,0-6.77,1.06,11,11,0,0,1-3.39.31c-.94,1.68-1.89,3.3-2.78,4.95-.68,1.25-1.49,2.58.55,3.27l-6.13,2,1.33-1.55-3.21-.39,0-.35c.42,0,.84,0,1.26-.08,1.94-.16,3.55-.73,4.19-2.89a16.14,16.14,0,0,1,1.44-3c.37-.7.22-1.08-.43-1.49a5.52,5.52,0,0,1-1.95-1.67,9.64,9.64,0,0,0-4.85-4.15c-3.58-1.67-6.11-7-5.49-10.82A2.55,2.55,0,0,1,224,421.23Z' /><path class='b' d='M240.25,404.56c-.66,2.54-1.39,3-6.37,4.09a16,16,0,0,0,1,1.36c2.25,2.57,2.27,5.82,2.63,8.93.08.71-.49,1.5-.81,2.42l-1.06-.08,1.16,2.89c-1.7,0-2-.14-5.39-2.52l-.32,2.18a13.09,13.09,0,0,1-1-.82c-.3-.3-.55-.65-1.09-1.32v3.68l-.4.1-1.25-5.34-1.61,1.74c-.82-2.66-.39-3.93,1.82-5.4.42-.29.86-.56,1.24-.88a1.76,1.76,0,0,0,.54-2.54,6.11,6.11,0,0,0-.92-1.59,6.06,6.06,0,0,0,0,1.65,1.73,1.73,0,0,1-1.24,2.27,2.06,2.06,0,0,1-1.69-.36,1.68,1.68,0,0,1-.16-2.47c.36-.53.83-1,1.33-1.6-1.37-1.17-2.72-.17-4.23-.06l4.27-8.59.62,2.73c1.11-1.28,2.11-2.46,3.17-3.69l.52,2.08,3.68-2c.47,1.9-1.64,2.34-1.74,4.16l3.93-1.34.27.12-2.59,2.14C236.28,407.28,238.15,406.86,240.25,404.56Z' /><path class='b' d='M243.34,438.77a11.6,11.6,0,0,1,1.82-.64,1.55,1.55,0,0,1,1.24.27,1.84,1.84,0,0,1,.38,1.4c-.31,1.23-.84,2.4-1.16,3.63-.27,1-.41,2.08.89,2.43l-4.39,1.93.22-1.22-2.59-.37C244.07,445.37,245.53,442.44,243.34,438.77Z' /><path class='b' d='M263.64,406.41l-5.76,3,.17.58c2.71-.41,5.42-.76,7.82,1a12.45,12.45,0,0,0-9,.4,18.76,18.76,0,0,0-7,6C251,413.62,259.37,406.93,263.64,406.41Z' /><path class='b' d='M247,419c1.95-6.68,4.87-12.69,11.48-15.93a12.16,12.16,0,0,1,4.72-.75c-6.08.4-9.54,4.35-12.35,9.07C249.4,413.85,248.27,416.48,247,419Z' /><path class='b' d='M265.55,415.66h-5.79l-.21.44c3.1,1.7,4.21,4.41,4.14,7.72-.62-2.29-1.17-4.64-3.21-6.15s-4.51-1.05-6.83-.23c3.62-2.49,7.82-1.73,11.8-2.17Z' /><path class='b' d='M247,419c1.95-6.68,4.87-12.69,11.48-15.93a12.16,12.16,0,0,1,4.72-.75c-6.08.4-9.54,4.35-12.35,9.07C249.4,413.85,248.27,416.48,247,419Z' />"
    ];
    string e = "</svg>";

    function getImg(uint256 _tokenId)
        public
        view
        returns (string memory)
    {
        return Base64.encode(bytes(string(abi.encodePacked(a, b[(determineInt(string(abi.encodePacked("CRAZY", _tokenId.toString()))) % b.length)], c, d[(determineInt(string(abi.encodePacked("COOKIES", _tokenId.toString()))) % d.length)], e))));
    }

    function determineInt(string memory _in) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_in)));
    }
}

library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}