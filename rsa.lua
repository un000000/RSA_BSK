local math2 = dofile('.\\modularMath.lua')

local P = 751
local Q = 811
local BLOCK_SIZE = math.ceil(math.log(P * Q, 10))

local function gcd(a, b)
    while b ~= 0 do
        a, b = b, a % b
    end
    return a
end
local function calculateExponent(e, phi)
    while (gcd(e, phi) ~= 1) do
        e = e + 2
    end
    return e
end

local function generateKeyPair()
    local N = P * Q
    local L = (P - 1) * (Q - 1)

    local E = 3
    E = calculateExponent(E, L)
    
    local D = math2.modInverse(E, L)
    return { E = E, N = N }, { D = D, N = N }
end

local function compliment(input)
    local str = tostring(input)
    str = string.sub(str, 1, #str - 2)
    local complimentCount = BLOCK_SIZE - #str
    local complimentString = string.rep("0", complimentCount)
    return complimentString .. str
end

local function encrypt(decryptedMessage, publicKey)
    local result = ""
    for i = 1, #decryptedMessage do
        local decryptedAsciiCode = string.byte(decryptedMessage, i)
        local encryptedNumber = math2.powerMod(decryptedAsciiCode, publicKey.E, publicKey.N)
        local encryptedChar = compliment(encryptedNumber)
        result = result .. encryptedChar
    end
    return result
end

local function decrypt(encryptedMessage, privateKey)
    local result = ""
    for i = 1, #encryptedMessage, BLOCK_SIZE do
        local encryptedSegment = tonumber(string.sub(encryptedMessage, i, i + BLOCK_SIZE - 1))
        local decryptedAsciiCode = math2.powerMod(encryptedSegment, privateKey.D, privateKey.N)
        local decryptedMessage = string.char(decryptedAsciiCode)
        result = result .. decryptedMessage
    end
    return result
end

local function Main(args)
    local publicKey, privateKey = generateKeyPair()
    local fileIn = assert(io.open(args.input, "rb"))
    fileIn:seek("set")
    local input = fileIn:read("*all")

    --read original, save encrypt to file
    local fileEncrypted = assert(io.open(args.outputEncrypted, "wb"))
    io.close(fileIn)
    local encryptedMessage = encrypt(input, publicKey)
    fileEncrypted:seek("set")
    fileEncrypted:write(encryptedMessage)
    fileEncrypted:close()

    --read encrypt, save decrypt to file
    local fileDecrypted = assert(io.open(args.outputDecrypted, "wb"))
    local fileEncryptedNew = assert(io.open(args.outputEncrypted, "rb"))
    fileDecrypted:seek("set")
    local encryptedFileContent = fileEncryptedNew:read("*all")
    local decryptedMessage = decrypt(encryptedFileContent, privateKey)
    fileDecrypted:write(decryptedMessage)
    fileDecrypted:close()
    fileEncryptedNew:close()
end

local originalName = "simpson"
local format = ".png"
local dir = "C:\\Users\\ehhh\\Documents\\test\\"
local p1 = {
    input = dir .. originalName .. format,
    outputEncrypted = dir .. originalName .. "Encrypted" .. format,
    outputDecrypted = dir .. originalName .. "Decrypted" .. format
}
Main(p1)
