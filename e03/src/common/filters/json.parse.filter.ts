import { ArgumentsHost, Catch, ExceptionFilter } from "@nestjs/common";
import { error } from "console";

@Catch(SyntaxError)
export class JsonParseException implements ExceptionFilter{
    catch(exception: SyntaxError, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse();
        response.status(400).json({ error: 'Bad Request' });
    }
}